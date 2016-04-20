//
//  AddFriendModel.m
//  XmppDemo
//
//  Created by clq on 16/3/24.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "AddFriendModel.h"

@implementation AddFriendModel

+ (instancetype)addFriendWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon
{
    AddFriendModel *addFriendModel = [[AddFriendModel alloc] init];
    addFriendModel.title = title;
    addFriendModel.subTitle = subTitle;
    addFriendModel.icon = icon;
    
    return addFriendModel;
}

@end
