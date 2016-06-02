//
//  HomeController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "HomeController.h"
#import "MySearchView.h"
#import "HomeViewCell.h"
#import "HomeModel.h"
#import "ChatController.h"

@interface HomeController ()<MySearchViewDelegate>

@property (nonatomic,strong) NSMutableArray *chatData; //存放最后一段信息的数组
@property (nonatomic,assign) int messageCount; //未读的消息总数
@property (nonatomic,strong) NSMutableArray *searchResult;
@property (nonatomic,weak) MySearchView *searchView;

@end

@implementation HomeController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)chatData
{
    if (_chatData == nil) {
        _chatData = [NSMutableArray array];
    }
    return _chatData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSearchBar]; //添加搜索栏
    [self setupRightButton]; //添加顶部导航栏右侧按钮
    [self loadChatData]; //从本地数据库中读取正在聊天的好友数据
    [self addNotification]; //添加消息通知
}

- (void)setupSearchBar
{
    MySearchView *mySearchView = [[MySearchView alloc] init];
    mySearchView.frame = CGRectMake(0, 64, ScreenWidth, 44);
    mySearchView.placeholder = NSLocalizedString(@"Home_text_search", comment:@"搜索");
    mySearchView.delegate = self;
    mySearchView.showsCancelButton = YES;
    mySearchView.searchResultsDataSource = self;
    mySearchView.searchResultsDelegate = self;
    
    self.tableView.tableHeaderView = mySearchView;
}

- (void)setupRightButton
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_add" highIcon:@"nav_add" target:self action:@selector(rightClick)];
}

- (void)rightClick
{
    
}

- (void)addNotification
{
    //监听新消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:SendMsgName object:nil];
    //监听删除好友时发出的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteFriend:) name:DeleteFriend object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//从本地库读取所有的聊天记录
- (void)loadChatData
{
    NSArray *array = [FmdbTool selectAllData];
    self.chatData = [array mutableCopy];
    //如果有未读消息的话，在标签下显示未读消息
    for (HomeModel *model in array) {
        if (model.badgeValue.length > 0 && ![model.badgeValue isEqualToString:@""]) {
            int cuurentValue = [model.badgeValue intValue];
            self.messageCount += cuurentValue;
        }
    }
    
    [self updateTabBarBadge];
    
}

- (void)updateTabBarBadge
{
    if (self.messageCount > 0) {
        if (self.messageCount >= 99) {
            self.tabBarItem.badgeValue = @"99+";
        }
        else {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",self.messageCount];
        }
    }
    else {
        self.tabBarItem.badgeValue = nil;
    }
}

#pragma mark 消息通知处理
- (void)newMessage:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    //设置未读消息总数消息，如果是正在和我聊天的用户才设置
    if ([dic[@"user"] isEqualToString:@"other"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageCount++;
            [self updateTabBarBadge];
        });
    }
    
    //更新信息
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateMessage:notification];
    });
    
}

- (void)updateMessage:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    NSString *userName = [dic objectForKey:@"username"];
    NSString *body = [dic objectForKey:@"body"];
    XMPPJID *jid = [dic objectForKey:@"jid"];
    NSString *time = [dic objectForKey:@"time"];
    NSString *user = [dic objectForKey:@"user"];
    
    //如果用户在本地数据库中已存在，就直接更新聊天数据
    if ([FmdbTool selectUname:jid.user]) {
        for (HomeModel *model in self.chatData) {
            if ([model.jid.user isEqualToString:jid.user]) {
                model.body = body;
                model.time = time;
                //如果是正在和我聊天的用户，才设置badgevalue
                if ([user isEqualToString:@"other"]) {
                    int currentValue = [model.badgeValue intValue] + 1;
                    model.badgeValue = [NSString stringWithFormat:@"%d",currentValue];
                }
                
                //刷新界面
                [self.tableView reloadData];
                //更新本地库文件
                [FmdbTool updateWithName:jid.user detailName:body time:time badge:model.badgeValue];
            }
        }
    }
    else { //没有的话，添加新的数据
        HomeModel *homeModel = [[HomeModel alloc] init];
        homeModel.username = userName;
        homeModel.body = body;
        homeModel.jid = jid;
        homeModel.time = time;
        if ([user isEqualToString:@"other"]) {
            homeModel.badgeValue = @"1";
        }
        else {
            homeModel.badgeValue = nil;
        }
        //刷新界面
        [self.chatData addObject:homeModel];
        [self.tableView reloadData];
        //更新本地库文件
        [FmdbTool addHead:nil uname:jid.user detailName:body time:time badge:homeModel.badgeValue xmppjid:jid];
    }
    
}

- (void)deleteFriend:(NSNotification *)notification
{
    NSString *userName = [notification object];
    NSUInteger index = 0;
    for (HomeModel *model in self.chatData) {
        if ([model.jid.user isEqualToString:userName]) {
            NSLog(@"HomeController deleteFriend %@    %@",model.jid.user,userName);
            [self.chatData removeObjectAtIndex:index];
            //从本地库数据库清除
            [FmdbTool deleteWithName:userName];
            //重新刷新界面
            [self.tableView reloadData];
        }
        
        index++;
    }
}

#pragma mark 搜索框代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchByString:searchText];
    [self.searchView.searchResultTableView reloadData];
}

- (void)searchByString:(NSString *)searchText{
    if (self.searchResult) {
        [self.searchResult removeAllObjects];
    }
    for (NSString *str in self.chatData) {
        if ([str rangeOfString:searchText].location != NSNotFound) {
            [self.searchResult addObject:str];
        }
    }
}

#pragma mark tableView设置
//返回行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//返回每行多少列
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatData.count;
}
//设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCell *cell = [HomeViewCell cellWithTableView:tableView cellWithIdentifier:@"homeviewcell"];
    HomeModel *homeModel = self.chatData[indexPath.row];
    cell.homeModel = homeModel;
    
    return cell;
}
//设置单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //更改标签页数据
    HomeModel *homeModel = self.chatData[indexPath.row];
    self.messageCount = self.messageCount - [homeModel.badgeValue intValue];
    [self updateTabBarBadge];
    
    //清除模型中的数据,并刷新界面，隐藏小红点
    homeModel.badgeValue = nil;
    [self.tableView reloadData];
    
    //更新本地数据库
    [FmdbTool clearRedPointwithName:homeModel.jid.user];
    
    //跳转到聊天页面
    ChatController *chatVC = [[ChatController alloc] init];
    if (homeModel.username == nil) {
         chatVC.title = homeModel.jid.user;
    }
    else {
        chatVC.title = homeModel.username;
    }
   
    chatVC.jid = homeModel.jid;
    [self.navigationController pushViewController:chatVC animated:YES];
}
//滑动删除单元格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//改变删除单元格按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Home_text_delete", comment:@"删除");;
}
//单元格按钮的点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *homeModel = self.chatData[indexPath.row];
    NSString *userName = homeModel.jid.user;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int badge = [homeModel.badgeValue intValue];
        if (badge > 0) {
            self.messageCount = self.messageCount - badge;
            [self updateTabBarBadge];
        }
        
        //删除该好友所有聊天数据
        [FmbdMessage deleteChatData:[NSString stringWithFormat:@"%@@%@",userName,ServerName]];
        //更新界面
        [self.chatData removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}
//滚动视图时停止编辑
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
//视图销毁时处理
- (void)dealloc
{
    [self removeNotification];
}
@end
