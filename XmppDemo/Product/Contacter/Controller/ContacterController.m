//
//  ContacterController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ContacterController.h"
#import "ContacterModel.h"
#import "ContacterTableCell.h"
#import "AddFriendController.h"
#import "NewFriendController.h"
#import "GroupChatController.h"
#import "MarkController.h"
#import "MySearchView.h"
#import "ChatController.h"
#import "MyTarBarController.h"

@interface ContacterController ()<XMPPRosterDelegate>

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultController;

@property (nonatomic,strong) NSMutableArray *allKeys; //存放所有分区的键值
@property (nonatomic,strong) NSMutableArray *friendKeys; //存放所有好友的键值
@property (nonatomic,strong) NSMutableDictionary *dataDic; //存放分组数据
@property (nonatomic,strong) NSMutableArray *localKeys; //存放固定数据
@property (nonatomic,strong) NSMutableArray *datas; //存放好友的jids

@property (nonatomic,strong) NSIndexPath *indexPath;//删除好友时候使用，记录即将要删除的行



@end

@implementation ContacterController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _allKeys = [NSMutableArray array];
        _friendKeys = [NSMutableArray array];
        _dataDic = [NSMutableDictionary dictionary];
        _localKeys = [NSMutableArray array];
        _datas = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化界面
    [self setupUI];
    //添加通知
    [self addNotification];
    //初始化通讯录数据
    [self setupData];
}

- (void)setupUI
{
    //1.设置tableView
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //2.设置导航栏
    [self setupRightButton];
    //3.添加搜索框
    [self setupSearchView];
    //4.添加固定标签
    [self setupRegularLbl];
}

- (void)setupData
{
    [self resetData];
    
    XmppTools *xmpp = [XmppTools sharedxmpp];
    
    NSArray *jids = [xmpp.rosterStorage jidsForXMPPStream:xmpp.xmppStream];
    _datas = [[NSMutableArray alloc] initWithArray:jids];
    
    [self devideFriend];
}

- (void)resetData
{
    [_dataDic removeAllObjects];
    [_allKeys removeAllObjects];
    [_friendKeys removeAllObjects];
    
    [_dataDic setObject:self.localKeys forKey:@"🔍"];
    [_allKeys addObject:@"🔍"];
}

- (void)devideFriend
{
    XmppTools *xmpp = [XmppTools sharedxmpp];
 
    for (XMPPJID *jid in _datas) {
        XMPPUserCoreDataStorageObject *user = [xmpp.rosterStorage userForJID:jid xmppStream:xmpp.xmppStream managedObjectContext:xmpp.rosterStorage.mainThreadManagedObjectContext];
        
        NSString *pinyin;
        if (user.nickname.length == 0) {
            pinyin = [NSString hanziToPinyin:user.jidStr];
        }
        else {
            pinyin = [NSString hanziToPinyin:user.nickname];
        }
        //获取首字母
        NSString *firstLetter = [pinyin substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];//转为大写
        
        ContacterModel *contacterModel = [[ContacterModel alloc] initWithUserCoreData:user];
        contacterModel.pinyin = pinyin;
        contacterModel.vcClass = [ChatController class];
        
        //根据key值获取对应的数组
        NSArray *array = [self.dataDic objectForKey:firstLetter];
        NSMutableArray *contacterArray;
        if (array == nil) {
            contacterArray = [NSMutableArray arrayWithObject:contacterModel];
        }
        else {
            contacterArray = [NSMutableArray arrayWithArray:array];
            [contacterArray addObject:contacterModel];
        }
        [self.dataDic setObject:contacterArray forKey:firstLetter];
    }
    

    //获取好友所有key值
    NSArray *keys = [self.dataDic allKeys];
    for (NSString *key in keys) {
        if (![key isEqualToString:@"🔍"]) {
            [self.friendKeys addObject:key];
        }
    }
    //排序key值后添加到所有keys
    NSArray *sortKeys = [self.friendKeys sortedArrayUsingSelector:@selector(compare:)];
    [self.allKeys addObjectsFromArray:sortKeys];
}

- (void)rosterChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupData];
        [self.tableView reloadData];
    });
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterChanged) name:FRIEND_POPULATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterChanged) name:FRIEND_CHANGED object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRightButton
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_addfriend" highIcon:@"nav_addfriend" target:self action:@selector(rightBtnClick)];
}

- (void)setupSearchView
{
    MySearchView *mySearchView = [[MySearchView alloc] init];
    mySearchView.frame = CGRectMake(0, 64, ScreenWidth, 44);
    mySearchView.placeholder =  NSLocalizedString(@"Contacter_text_search", comment:@"搜索");
   // mySearchView.delegate = self;
    mySearchView.showsCancelButton = YES;
    mySearchView.searchResultsDataSource = self;
    mySearchView.searchResultsDelegate = self;
    
    self.tableView.tableHeaderView = mySearchView;

}


- (void)setupRegularLbl
{
    //1.新的朋友
    ContacterModel *newFriendModel = [[ContacterModel alloc] init];
    newFriendModel.nickname = NSLocalizedString(@"Contacter_text_newFriend", comment:@"新的朋友");
    newFriendModel.photo = [UIImage imageNamed:@"contacter_icon_newfriend"];
    newFriendModel.vcClass = [NewFriendController class];
    
    //2.群聊
    ContacterModel *groupChatModel = [[ContacterModel alloc] init];
    groupChatModel.nickname = NSLocalizedString(@"Contacter_text_groupChat", comment:@"群聊");
    groupChatModel.photo = [UIImage imageNamed:@"contacter_icon_groupchat"];
    groupChatModel.vcClass = [GroupChatController class];

    //3.标签
    ContacterModel *markModel = [[ContacterModel alloc] init];
    markModel.nickname = NSLocalizedString(@"Contacter_text_mark", comment:@"标签");
    markModel.photo = [UIImage imageNamed:@"contacter_icon_mark"];
    markModel.vcClass = [MarkController class];
    
    NSArray *array = @[newFriendModel,groupChatModel,markModel];
    [_localKeys addObjectsFromArray:array];
}


#pragma mark 点击事件
//导航栏右侧按钮点击事件
- (void)rightBtnClick
{
    AddFriendController *addFriendController = [[AddFriendController alloc] init];
    addFriendController.title = NSLocalizedString(@"Contacter_text_addFriend", comment:@"添加朋友");
    [self.navigationController pushViewController:addFriendController animated:YES];
}

#pragma mark tableView设置
//返回多少个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allKeys.count;
}
//返回每个区有多少个行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.allKeys[section];
    NSArray *array = [self.dataDic objectForKey:key];
    return array.count;
}
//返回分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else {
        return 10;
    }
}
//设置每个区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //第一个分区不用设置
    if (section == 0) {
        return nil;
    }
    
    NSString *title = self.allKeys[section];
    
    return title;
}
//返回表示图的索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allKeys;
}
//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContacterTableCell *cell = [ContacterTableCell cellWithTablevView:tableView identifier:@"contactercell"];
    
    //单元格数据设置
    NSString *key = self.allKeys[indexPath.section];
    NSArray *array = [self.dataDic objectForKey:key];
    ContacterModel *contacterModel = array[indexPath.row];
    cell.contacterModel = contacterModel;
    
    return cell;
}
//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.allKeys[indexPath.section];
    NSArray *array = [self.dataDic objectForKey:key];
    ContacterModel *contacterModel = array[indexPath.row];
    
    if (contacterModel.vcClass != nil) {
        if ([contacterModel.vcClass isSubclassOfClass:[ChatController class]]) {
            ChatController *chatVC = [[ChatController alloc] init];
            
            chatVC.contacterModel = contacterModel;
            
            MyTarBarController *vc = (MyTarBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            vc.selectedIndex = 0;
            [vc.home.navigationController pushViewController:chatVC animated:YES];
        }
        else {
            [self.navigationController pushViewController:[[contacterModel.vcClass alloc] init] animated:YES];
        }
    }
}
//滑动删除单元格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//改变删除单元格按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Contacter_btn_delete", comment:@"删除");
}
//单元格删除的点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当点击删除按钮的时候执行
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.indexPath = indexPath;
        //弹出确认删除提示框
        [self alertDelete];
    }
}
//弹出确认删除提示框
- (void)alertDelete
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Contacter_text_reminder", comment:@"温馨提示") message:NSLocalizedString(@"Contacter_text_deleteTip", comment:@"您确定要删除该好友吗？") preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Contacter_btn_delete", comment:@"删除") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self deleteFriend];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Contacter_btn_cancel", comment:@"取消")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//删除好友
- (void)deleteFriend
{
    NSString *key = self.allKeys[self.indexPath.section];
    NSMutableArray *array = [self.dataDic objectForKey:key];
    ContacterModel *contacterModel = array[self.indexPath.row];
    NSString *uname = contacterModel.name;
    
    //分组只有一个好友时候，删除分组
    if (array.count <= 1) {
        [self.allKeys removeObjectAtIndex:self.indexPath.section];
    }
    [array removeObjectAtIndex:self.indexPath.row];
    
    //花名册上移除该好友
    XmppTools *xmpp = [XmppTools sharedxmpp];
    [xmpp.roster removeUser:contacterModel.jid];
    
    //清楚首页对该还有的监听
    NSNotification *notification = [[NSNotification alloc] initWithName:DeleteFriend object:uname userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //刷新好友列表
    [self.tableView reloadData];
}
- (void)dealloc
{
    [self removeNotification];
}

@end
