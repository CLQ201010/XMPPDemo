//
//  UserOperation.h
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserOperation : NSObject
SingletonH(user);
//把用户和密码保存到沙盒
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *password;
//登陆状态
@property (nonatomic,assign) NSInteger loginStatus;// -1:未登陆过；0:登陆过；1登陆状态

+ (void)loginByStatus;

@end
