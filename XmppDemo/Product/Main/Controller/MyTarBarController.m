//
//  MyTarBarController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "MyTarBarController.h"
#import "MyNavController.h"
#import "HomeController.h"
#import "ContacterController.h"
#import "DiscoverController.h"
#import "MeController.h"
#import "CustomTabView.h"

@interface MyTarBarController ()<CustomTabViewDelegate>

@property (nonatomic,weak) CustomTabView *customTbabar;

@property (nonatomic,strong) HomeController *home;
@property (nonatomic,strong) ContacterController *contacter;
@property (nonatomic,strong) DiscoverController *discover;
@property (nonatomic,strong) MeController *me;

@end

@implementation MyTarBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabbar];
    [self setupChildControllers];
}

- (void)setupTabbar
{
    CustomTabView *customTabbar = [[CustomTabView alloc] init];
    customTabbar.delegate = self;
    customTabbar.frame = self.tabBar.frame;
    
    [self.tabBar addSubview:customTabbar];
    self.customTbabar = customTabbar;
}

- (void)tabBar:(CustomTabView *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:imageName];
    
    MyNavController *nav = [[MyNavController alloc] initWithRootViewController:childVc];
    //添加到标签控制器里面
    [self addChildViewController:nav];
    //把UIBarItem属性传递给自定义的view
    [self.customTbabar addTabBarButtonItem:childVc.tabBarItem];
}

- (void)setupChildControllers
{
    //1.首页
    HomeController *home = [[HomeController alloc] init];
    self.home = home;
    [self setupChildViewController:home title: NSLocalizedString(@"Main_text_home", comment:@"微信") imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
    //2.通讯录
    ContacterController *contacter = [[ContacterController alloc] init];
    self.contacter = contacter;
    [self setupChildViewController:contacter title:NSLocalizedString(@"Main_text_contacter", comment:@"通讯录")  imageName:@"tabbar_contacts" selectedImageName:@"tabbar_contactsHL"];
    //3.发现
    DiscoverController *discover = [[DiscoverController alloc] init];
    self.discover = discover;
    [self setupChildViewController:discover title:NSLocalizedString(@"Main_text_discover", comment:@"发现") imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
    //4.我
    MeController *me = [[MeController alloc] init];
    self.me = me;
    [self setupChildViewController:me title:NSLocalizedString(@"Main_text_me", comment:@"我")  imageName:@"tabbar_me" selectedImageName:@"tabbar_meHL"];
}

//返回白色的状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
