//
//  NewFriendModel.h
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewFriendModel : NSObject

@property (nonatomic,strong) NSString *icon; //头像
@property (nonatomic,strong) XMPPJID *jid; //名称
@property (nonatomic,strong) NSString *content; //说明信息
@property (nonatomic,strong) NSString *acceptBtn; //接受按钮
@property (nonatomic,strong) NSString *rejectBtn; //拒绝按钮

+ (instancetype)initWithName:(XMPPJID *)jid icon:(NSString *)icon content:(NSString *)content acceptBtn:(NSString *)acceptBtn rejectBtn:(NSString *)rejectBtn;

@end
