//
//  HomeModel.h
//  XmppDemo
//
//  Created by clq on 16/1/16.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
//聊天用户的头像头像
@property (nonatomic,copy) NSData *headerIcon;
//标题
@property (nonatomic,copy) NSString *username;
//子标题
@property (nonatomic,copy) NSString *body;
//时间
@property (nonatomic,copy) NSString  *time;
//jid
@property (nonatomic,strong) XMPPJID *jid; //聊天用户的jid
//数字提醒按钮
@property (nonatomic,copy) NSString *badgeValue;
@end

