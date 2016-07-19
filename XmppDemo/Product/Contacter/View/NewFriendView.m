//
//  NewFriendView.m
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NewFriendView.h"
#import "NewFriendModelFrame.h"

@interface NewFriendView ()

@property (nonatomic,weak) UIImageView *iconImgView;
@property (nonatomic,weak) UILabel *nameLbl;
@property (nonatomic,weak) UILabel *contentLbl;
@property (nonatomic,weak) UIButton *acceptBtn;
@property (nonatomic,weak) UIButton *rejectBtn;
@end

@implementation NewFriendView

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
    self.backgroundColor = [UIColor whiteColor];

    //1.头像
    UIImageView *iconImgView = [[UIImageView alloc] init];
    [self addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    //2.名称
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.font = [UIFont systemFontOfSize:16.0];
    nameLbl.textColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0];
    [self addSubview:nameLbl];
    self.nameLbl = nameLbl;
    
    //3.说明信息
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.font = [UIFont systemFontOfSize:12.0];
    contentLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:contentLbl];
    self.contentLbl = contentLbl;
    
    //4.添加按钮
    UIButton *rejectBtn = [[UIButton alloc] init];
    rejectBtn.backgroundColor = [UIColor lightGrayColor];
    rejectBtn.layer.cornerRadius = 4;
    [rejectBtn setTitleColor:[UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0] forState:UIControlStateNormal];
    rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [rejectBtn addTarget:self action:@selector(rejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rejectBtn];
    self.rejectBtn = rejectBtn;
    
    //5.接受按钮
    UIButton *acceptBtn = [[UIButton alloc] init];
    acceptBtn.backgroundColor = [UIColor greenColor];
    acceptBtn.layer.cornerRadius = 4;
    [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptBtn];
    self.acceptBtn = acceptBtn;
}

- (void)rejectBtnClick
{
    //拒绝的方法
    XmppTools *xmpp = [XmppTools sharedxmpp];
    [xmpp.roster rejectPresenceSubscriptionRequestFrom:_friendModelFrame.friendModel.jid];
    
}

- (void)acceptBtnClick
{
    XmppTools *xmpp = [XmppTools sharedxmpp];
    //同意并添加对方为好友
    [xmpp.roster acceptPresenceSubscriptionRequestFrom:_friendModelFrame.friendModel.jid andAddToRoster:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_ACCEPT_FRRIEND object:_friendModelFrame];
}

- (void)setFriendModelFrame:(NewFriendModelFrame *)friendModelFrame
{
    _friendModelFrame = friendModelFrame;
    NewFriendModel *friendModel = _friendModelFrame.friendModel;
    
    //1.头像
    if (friendModel.icon)
    {
        self.iconImgView.image = [UIImage imageNamed:friendModel.icon];
    }
    else
    {
        self.iconImgView.image = [UIImage imageNamed:@"me_icon_defaultuser"];
    }
    self.iconImgView.frame = _friendModelFrame.iconFrame;
    
    //2.名称
    self.nameLbl.text = friendModel.jid.user;
    self.nameLbl.frame = _friendModelFrame.nameFrame;
    
    //3.说明信息
    self.contentLbl.text = friendModel.content;
    self.contentLbl.frame = _friendModelFrame.contentFrame;
    
    //4.拒绝按钮
    [self.rejectBtn setTitle:friendModel.rejectBtn forState:UIControlStateNormal];
    self.rejectBtn.frame = _friendModelFrame.rejectBtnFrame;
    
    //5.接受按钮
    [self.acceptBtn setTitle:friendModel.acceptBtn forState:UIControlStateNormal];
    self.acceptBtn.frame = _friendModelFrame.acceptBtnFrame;

}

@end
