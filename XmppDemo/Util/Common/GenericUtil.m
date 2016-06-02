//
//  GenericUtil.m
//  XmppDemo
//
//  Created by clq on 16/6/1.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "GenericUtil.h"

@implementation GenericUtil


+ (UIViewController *)rootViewController
{
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (vc.presentedViewController != nil)
    {
        vc = vc.presentedViewController;
    }
    
    return vc;
}

@end
