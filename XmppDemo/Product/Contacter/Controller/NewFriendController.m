//
//  NewFriendController.m
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NewFriendController.h"
#import "NewFriendTableViewCell.h"
#import "SubscribeOperation.h"
#import "NewFriendModelFrame.h"

@interface NewFriendController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation NewFriendController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //1.界面初始化
    [self setupUI];
    //2.初始化数据
    [self setupData];
    //3.添加通知
    [self addNotification];
}

- (void)setupUI
{
    //1.设置导航栏
    self.title = NSLocalizedString(@"Contacter_text_newFriend", comment:@"新的朋友");
    
    //2.设置tableView
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)setupData
{
    SubscribeOperation *subscribe = [SubscribeOperation sharedSubscribe];
    [self xmppJidToModel:subscribe.datas];
    [self.tableView reloadData];
}

- (NSMutableArray *)datas
{
    if (_datas == nil)
    {
        _datas = [[NSMutableArray alloc] init];
    }
    
    return _datas;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddFriendRequest:) name:REQUEST_ADD_FPRIEND object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleAddFriendRequest:(NSNotification *)notification
{
    SubscribeOperation *subscribe = [SubscribeOperation sharedSubscribe];
    [self xmppJidToModel:subscribe.datas];
    [self.tableView reloadData];
}

- (void)xmppJidToModel:(NSMutableArray *)dataArray
{
    [self.datas removeAllObjects];
    
    for (XMPPJID *jid in dataArray)
    {
        NewFriendModelFrame *friendModelFrame = [[NewFriendModelFrame alloc] init];
        friendModelFrame.friendModel = [NewFriendModel initWithName:jid icon:nil content:@"需要支持验证信息" acceptBtn:NSLocalizedString(@"Contacter_text_accept", @"接受") rejectBtn:NSLocalizedString(@"Contacter_text_reject", @"拒绝")];
        [self.datas addObject:friendModelFrame];
    }
}


#pragma mark UITableView  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendTableViewCell *cell = [NewFriendTableViewCell cellWithTableView:tableView identifier:@"newfriendcell"];
    cell.friendModelFrame = self.datas[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)dealloc
{
    [self removeNotification];
}

@end
