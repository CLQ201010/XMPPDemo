//
//  NormalView.m
//  XmppDemo
//
//  Created by clq on 16/5/27.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NormalSearchView.h"
#import "UserSearchModel.h"

@interface NormalSearchView ()

@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *titleLbl;

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
    addBtn.backgroundColor = [UIColor blueColor];
    addBtn.titleLabel.textColor = [UIColor whiteColor];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn setTitle:NSLocalizedString(@"Common_text_add", @"添加") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
}

- (void)addBtnClick
{
    //添加好友
    XmppTools *xmpp = [XmppTools sharedxmpp];
    XMPPJID *jid = [XMPPJID jidWithUser:_userSearchModel.userName domain:ServerName resource:nil];
    [xmpp.roster subscribePresenceToUser:jid];
 
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
}

@end
