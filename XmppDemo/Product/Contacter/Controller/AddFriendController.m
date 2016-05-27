//
//  AddFriendController.m
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "AddFriendController.h"
#import "AddFriendTableCell.h"
#import "AddFriendModelFrame.h"

@interface AddFriendController ()

@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation AddFriendController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray *)datas
{
    if (_datas == nil)
    {
        _datas = [[NSMutableArray alloc] init];

        AddFriendModel *radar = [AddFriendModel addFriendWithTitle:NSLocalizedString(@"Contacter_text_addRadarFriend", comment:@"雷达加朋友") subTitle:NSLocalizedString(@"Contacter_text_addRadarFriendTip", comment:@"添加身边的朋友") icon:@"me_icon_emoji"];
        [_datas addObject:radar];
        
        AddFriendModel *group = [AddFriendModel addFriendWithTitle:NSLocalizedString(@"Contacter_text_createGroup", comment:@"面对面建群") subTitle:NSLocalizedString(@"Contacter_text_createGroupTip", comment:@"与身边的朋友进入同一个群聊") icon:@"me_icon_emoji"];
        [_datas addObject:group];
        
        AddFriendModel *scabQr = [AddFriendModel addFriendWithTitle:NSLocalizedString(@"Contacter_text_scanQr", comment:@"扫一扫") subTitle:NSLocalizedString(@"Contacter_text_scanQrTip", comment:@"扫描二维码名片") icon:@"me_icon_emoji"];
        [_datas addObject:scabQr];
        
        AddFriendModel *contacter = [AddFriendModel addFriendWithTitle:NSLocalizedString(@"Contacter_text_addContacter", comment:@"手机联系人") subTitle:NSLocalizedString(@"Contacter_text_addContacterTip", comment:@"添加或邀请通讯录中的朋友") icon:@"me_icon_emoji"];
        [_datas addObject:contacter];
        
        AddFriendModel *public = [AddFriendModel addFriendWithTitle:NSLocalizedString(@"Contacter_text_publicNumber", comment:@"公众号") subTitle:NSLocalizedString(@"Contacter_text_publicNumberTip", comment:@"获取更多资讯和服务") icon:@"me_icon_emoji"];
        [_datas addObject:public];
    }
    
    return _datas;
}
- (void)rightBtnClick
{
    [[XmppTools sharedxmpp] searchByUserName:@"1"];
//    NSString *userName = [NSString Trim:self.myTextFiled.text];
//    if ([userName isEqualToString:@""]) {
//        return;
//    }
//    
//    //添加好友
//    XmppTools *xmpp = [XmppTools sharedxmpp];
//    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:ServerName resource:nil];
//    
//    //判断是否是自己
//    UserOperation *user = [UserOperation shareduser];
//    NSString *meName = user.userName;
//    if ([meName isEqualToString:userName]) {
//        [self showMessage:@"不能添加自己为好友"];
//        return;
//    }
//    //判断好友是否已添加过
//    if ([xmpp.rosterStorage userExistsWithJID:jid xmppStream:xmpp.xmppStream]) {
//        [self showMessage:@"此用户已经是您的好友了！"];
//        return;
//    }
//    
//    [xmpp.roster subscribePresenceToUser:jid];
}

-(void)showMessage:(NSString *)msg
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Contacter_text_reminder", comment:@"温馨提示") message:msg preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Contacter_text_OK", comment:@"好的") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIView *)setupHeaderView
{
    CGFloat viewW = self.view.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, 100)];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    
    //1.设置编辑按钮
    NSString *title = NSLocalizedString(@"Contacter_text_userNameTip", comment:@"微信号/手机号");
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, viewW, 44)];
    editBtn.backgroundColor = [UIColor whiteColor];
    [editBtn setImage:[UIImage imageNamed:@"contacter_icon_search"] forState:UIControlStateNormal];
    [editBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, viewW - 60)];
    [editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [editBtn setTitle:title forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewW - titleSize.width - 60)];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:editBtn];
    
    //2.设置我的账号
    UserOperation * user = [UserOperation shareduser];
    NSString *myAccount = [NSString stringWithFormat:NSLocalizedString(@"Contacter_text_myAccount", comment:@"我的账号:%@"),user.userName];
    CGSize accountSize = [myAccount sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
    
    CGFloat accountW = accountSize.width;
    CGFloat accountH = accountSize.height;
    CGFloat accountX = (viewW - accountW - 10 - 16) * 0.5;
    CGFloat accountY = CGRectGetMaxY(editBtn.frame) + 10;
    UILabel *accountLbl = [[UILabel alloc] initWithFrame:CGRectMake(accountX, accountY, accountW, accountH)];
    accountLbl.textColor = [UIColor colorWithRed:9/255.0 green:9/255.0 blue:9/255.0 alpha:1.0];
    accountLbl.font = [UIFont systemFontOfSize:12.0];
    accountLbl.text = myAccount;
    [view addSubview:accountLbl];
    
    //3.添加二维码信息按钮
    CGFloat qrCodeX = CGRectGetMaxX(accountLbl.frame) + 10;
    CGFloat qrCodeY = CGRectGetMaxY(editBtn.frame) + 10;
    CGFloat qrCodeW = 16;
    CGFloat qrCodeH = 16;
    UIButton *qrCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(qrCodeX, qrCodeY, qrCodeW, qrCodeH)];
    qrCodeBtn.backgroundColor = [UIColor blueColor];
    [qrCodeBtn addTarget:self action:@selector(qrCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:qrCodeBtn];
    
    return view;
}

#pragma mark 按钮点击事件
// 编辑框点击事件
- (void)editBtnClick
{
    
}

- (void)qrCodeBtnClick
{
    
}

#pragma mark tableView事件

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFriendTableCell *cell = [AddFriendTableCell cellWithTableView:tableView identifier:@"addfriendcell"];
    AddFriendModelFrame *frame = [[AddFriendModelFrame alloc] init];
    frame.addFriendModel = self.datas[indexPath.row];
    cell.addFriendModelFrame = frame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [self setupHeaderView];
    return view;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
