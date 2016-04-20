//
//  AddFriendModel.h
//  XmppDemo
//
//  Created by clq on 16/3/24.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFriendModel : NSObject

@property (nonatomic,copy) NSString *title;  //标题
@property (nonatomic,copy) NSString *subTitle; //副标题
@property (nonatomic,copy) NSString *icon;  //图标

+ (instancetype)addFriendWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon;

@end
