//
//  CustomTabView.h
//  XmppDemo
//
//  Created by clq on 16/1/14.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTabView;

@protocol CustomTabViewDelegate <NSObject>

-(void) tabBar:(CustomTabView *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface CustomTabView : UIView

- (void)addTabBarButtonItem:(UITabBarItem *)item;

@property (nonatomic,weak) id<CustomTabViewDelegate>delegate;

@end
