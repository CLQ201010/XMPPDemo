//
//  MeController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//
#import "MeController.h"
#import "UserInfoController.h"
#import "PhotoController.h"
#import "CollectController.h"
#import "WalletController.h"
#import "UserSettingController.h"
#import "EmojiController.h"

@implementation MeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self addNotification];
}

- (void)setupData
{
    //获取用户名片
    XmppTools *xmpp = [XmppTools sharedxmpp];
    XMPPvCardTemp *cardTemp = xmpp.vCard.myvCardTemp;
    
    //1.用户名片模块
    GroupTableModel *group1 = [[GroupTableModel alloc] init];
    TableCellModel *userInfo= [TableCellModel itemWithIcon:@"me_icon_defaultuser" title:NSLocalizedString(@"Me_text_user", comment:@"用户") detailTitle:@"" vcClass:[UserInfoController class]];
    //获得用户图片
    userInfo.imageData = cardTemp.photo;
    //userInfo.title = cardTemp.nickname;
    group1.items = @[userInfo];
    [self.datas addObject:group1];
    //2.用户功能模块
    GroupTableModel *group2 = [[GroupTableModel alloc] init];
    
    TableCellModel *photoModel = [TableCellModel itemWithIcon:@"me_icon_photo" title:NSLocalizedString(@"Me_text_photo", comment:@"照片") detailTitle:@"" vcClass:[PhotoController class]];
    TableCellModel *collectModel = [TableCellModel itemWithIcon:@"me_icon_collect" title:NSLocalizedString(@"Me_text_collect", comment:@"收藏") detailTitle:@"" vcClass:[CollectController class]];
    TableCellModel *walletController = [TableCellModel itemWithIcon:@"me_icon_wallet" title:NSLocalizedString(@"Me_text_wallet", comment:@"钱包") detailTitle:@"" vcClass:[WalletController class]];
    group2.items = @[photoModel,collectModel,walletController];
    [self.datas addObject:group2];
    //3.表情管理模块
    GroupTableModel *group3 = [[GroupTableModel alloc] init];
    TableCellModel *emojiModel = [TableCellModel itemWithIcon:@"me_icon_emoji" title:NSLocalizedString(@"Me_text_emoji", comment:@"表情") detailTitle:@"" vcClass:[EmojiController class]];
    group3.items = @[emojiModel];
    [self.datas addObject:group3];
    //4.用户设置模块
    GroupTableModel *group4 = [[GroupTableModel alloc] init];
    TableCellModel *userSetting = [TableCellModel itemWithIcon:@"me_icon_setting" title:NSLocalizedString(@"Me_text_setting", comment:@"设置") detailTitle:@"" vcClass:[UserSettingController class]];
    group4.items = @[userSetting];
    [self.datas addObject:group4];
}

- (void)changeIcon:(NSNotification *)notification
{
    
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeIcon:) name:@"changeIcon" object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self removeNotification];
}

@end
