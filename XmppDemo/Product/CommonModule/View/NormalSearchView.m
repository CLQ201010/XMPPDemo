//
//  NormalView.m
//  XmppDemo
//
//  Created by clq on 16/5/27.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NormalSearchView.h"
#import "UserSearchModel.h"
#import "ChatController.h"
#import "MyTarBarController.h"

@interface NormalSearchView ()

@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *titleLbl;
@property (nonatomic,weak) UIButton *addBtn;
@property (nonatomic,weak) UIButton *sendBtn;

@end

@implementation NormalSearchView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    //1.添加图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(15, 7, 30, 30);
    [self addSubview:iconView];
    self.iconView = iconView;
    
    //2.添加标题
    UILabel *titleLbl = [[UILabel alloc] init];
    CGFloat titleX = CGRectGetMaxX(iconView.frame) + 10;
    titleLbl.frame = CGRectMake(titleX, 7, 200, 30);
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textColor = [UIColor blackColor];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    //3.添加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.frame = CGRectMake(ScreenWidth - 60, 10, 50, 25);
    addBtn.layer.cornerRadius = 4;
    addBtn.hidden = YES;
    addBtn.backgroundColor = [UIColor blueColor];
    addBtn.titleLabel.textColor = [UIColor whiteColor];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addBtn setTitle:NSLocalizedString(@"Common_text_add", @"添加") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    self.addBtn = addBtn;
    
    //4.发消息按钮
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.frame = CGRectMake(ScreenWidth - 60, 10, 50, 25);
    sendBtn.layer.cornerRadius = 4;
    sendBtn.hidden = YES;
    sendBtn.backgroundColor = [UIColor blueColor];
    sendBtn.titleLabel.textColor = [UIColor whiteColor];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendBtn setTitle:NSLocalizedString(@"Common_text_sendMessage", @"发消息") forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    self.sendBtn = sendBtn;
}

- (void)addBtnClick
{
    //添加好友
    XmppTools *xmpp = [XmppTools sharedxmpp];
    [xmpp.roster subscribePresenceToUser:_userSearchModel.jid];
 
}

- (void)sendBtnClick
{
//    ChatController *chatVC = [[ChatController alloc] init];
//    chatVC.title = _userSearchModel.userName;
//    chatVC.jid = _userSearchModel.jid;
}

- (void)setUserSearchModel:(UserSearchModel *)userSearchModel
{
    _userSearchModel = userSearchModel;
    
    self.iconView.image = [UIImage imageNamed:@"me_icon_defaultuser"];
    if (![_userSearchModel.nickName isEqualToString:@""])
    {
        self.titleLbl.text = _userSearchModel.nickName;
    }
    else
    {
        self.titleLbl.text = _userSearchModel.userName;
    }
    
    if (_userSearchModel.isAdded)
    {
        self.sendBtn.hidden = NO;
    }
    else
    {
        self.addBtn.hidden = NO;
    }
}

@end
