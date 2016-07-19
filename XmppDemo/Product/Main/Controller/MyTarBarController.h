//
//  MyTarBarController.h
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeController.h"
#import "ContacterController.h"
#import "DiscoverController.h"
#import "MeController.h"

@interface MyTarBarController : UITabBarController

@property (nonatomic,strong) HomeController *home;
@property (nonatomic,strong) ContacterController *contacter;
@property (nonatomic,strong) DiscoverController *discover;
@property (nonatomic,strong) MeController *me;

@end
