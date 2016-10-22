//
//  UserOperation.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "MyTarBarController.h"
#import "MyNavController.h"
#import "LoginController.h"


@implementation UserOperation
SingletonM(user);

- (void)setUserName:(NSString *)userName
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    [defaultUser setObject:userName forKey:@"username"];
    [defaultUser synchronize];
}

- (void)setPassword:(NSString *)password
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    [defaultUser setObject:password forKey:@"password"];
    [defaultUser synchronize];
}

- (void)setLoginStatus:(NSInteger)loginStatus
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    [defaultUser setInteger:loginStatus forKey:@"loginstatus"];
    [defaultUser synchronize];
}

- (NSString *)userName
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSString *name= [defaultUser objectForKey:@"username"];
    return name;
}

- (NSString *)password
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaultUser objectForKey:@"password"];
    return password;
}

- (NSInteger)loginStatus
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSInteger status = [defaultUser integerForKey:@"loginstatus"];
    return status;
}

+ (void)loginByStatus
{
    UserOperation *user = [UserOperation shareduser];
    if (user.loginStatus == 1) {
        XmppTools *xmpp = [XmppTools sharedxmpp];
        [xmpp login:nil];
        UserOperation *user = [UserOperation shareduser];
        [FmbdMessage initWithUser:user.userName];
        [FmdbTool initWithUser:user.userName];
        //登陆状态，直接跳转到首页
        MyTarBarController *tab = [[MyTarBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    }
    else if(user.loginStatus == 0) {
        //登陆过，默认填写上次号码
        LoginController *login = [[LoginController alloc] init];
        MyNavController *nav = [[MyNavController alloc] initWithRootViewController:login];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }
    else {
        //未登陆过
        LoginController *login = [[LoginController alloc] init];
        MyNavController *nav = [[MyNavController alloc] initWithRootViewController:login];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }
}

@end
