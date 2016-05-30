//
//  NewFriendModel.m
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NewFriendModel.h"

@implementation NewFriendModel

+ (instancetype)initWithName:(XMPPJID *)jid icon:(NSString *)icon content:(NSString *)content acceptBtn:(NSString *)acceptBtn rejectBtn:(NSString *)rejectBtn
{
    NewFriendModel *model = [[NewFriendModel alloc] init];
    model.jid = jid;
    model.icon = icon;
    model.content = content;
    model.acceptBtn = acceptBtn;
    model.rejectBtn = rejectBtn;
    
    return model;
}

@end
