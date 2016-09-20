//
//  XmppTools.h
//  微信
//
//  Created by Think_lion on 15/6/16.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPReconnect.h"
#import "XMPPvCardCoreDataStorage.h"

typedef enum{
    XMPPResultSuccess,   //登陆成功
    XMPPResultFaiture,     //登陆失败
    XMPPResultNetworkErr,  //网络出错
    XMPPResultRegisterSuccess,  //注册成功
    XMPPResultRegisterFailture,  //注册失败
    XMPPResultRegisterExist, //账户已存在
} XMPPResultType;
//定义一个block
typedef  void (^XMPPResultBlock)(XMPPResultType xmppType);



@interface XmppTools : NSObject
SingletonH(xmpp); //实现单例
//xmppstream  流
@property (nonatomic,strong) XMPPStream *xmppStream;
//定义一个xmppJid
@property (nonatomic,strong) XMPPJID *jid;
@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;  //如果是YES就是注册的方法
//添加花名册模块
@property (nonatomic,strong,readonly) XMPPRoster *roster;
@property (nonatomic,strong,readonly) XMPPRosterCoreDataStorage *rosterStorage;
//聊天模块
@property (nonatomic,strong,readonly) XMPPMessageArchivingCoreDataStorage *messageStroage;
//电子名片
@property (nonatomic,strong,readonly) XMPPvCardTempModule *vCard;
//头像模块
@property (nonatomic,strong,readonly) XMPPvCardAvatarModule  *avatar;

//登陆的方法
- (void)login:(XMPPResultBlock)xmppBlock;
//退出的方法
- (void)xmppLoginOut;  //退出登录的操作
//注册的方法
- (void)regist:(XMPPResultBlock)xmppType;

- (void)searchByUserName:(NSString *)userName;

@end
