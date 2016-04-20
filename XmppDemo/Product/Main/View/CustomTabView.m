//
//  CustomTabView.m
//  XmppDemo
//
//  Created by clq on 16/1/14.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "CustomTabView.h"
#import "TabbarButton.h"

@interface CustomTabView ()

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,weak) TabbarButton *tabButton;

@end

@implementation CustomTabView

- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray arrayWithCapacity:5];
    }
    
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)addTabBarButtonItem:(UITabBarItem *)item
{
    TabbarButton *tabButton = [[TabbarButton alloc] init];
    [self addSubview:tabButton];
    [self.buttons addObject:tabButton];
    
    tabButton.item = item;
    [tabButton addTarget:self action:@selector(tabButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tabButtonClick:(TabbarButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.tabButton.tag to:sender.tag];
    }
    
    self.tabButton.selected = NO;
    sender.selected = YES;
    self.tabButton = sender;
}

- (void)layoutSubviews
{
    [super subviews];
    CGFloat btnW = self.width/self.buttons.count;
    CGFloat btnH = self.height;
    CGFloat btnY = 0;
    
    for (int i = 0; i < self.buttons.count; i++) {
        TabbarButton *tabButton = self.buttons[i];
        tabButton.tag = i;
        CGFloat btnX = i * btnW;
        tabButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}

@end
