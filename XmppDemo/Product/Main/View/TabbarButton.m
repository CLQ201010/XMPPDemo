//
//  TabbarButton.m
//  XmppDemo
//
//  Created by clq on 16/1/14.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "TabbarButton.h"
#import "BadgeButton.h"
#define tabbarButtonImageRatio 0.65

@interface TabbarButton()

@property (nonatomic,weak) BadgeButton *badgeButton; //提醒数字按钮

@end

@implementation TabbarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        //添加数字提醒
        BadgeButton *badge = [[BadgeButton alloc] init];
        badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:badge];
        self.badgeButton = badge;
    }
    
    return self;
}

#pragma mark 属性设置
- (void)setHighlighted:(BOOL)highlighted
{
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * tabbarButtonImageRatio;
    
    return CGRectMake(0, 0, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * tabbarButtonImageRatio;
    CGFloat titleH = contentRect.size.height - imageH;
    
    return CGRectMake(0, 0, titleW, titleH);
}

#pragma mark 设置item

- (void)setItem:(UITabBarItem *)item
{
    _item=item;
    //1.KVO  监听属性值的改变
    
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    
    //设置按钮的颜色
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
    //添加提醒数字按钮
    self.badgeButton.badgeValue=item.badgeValue;
    self.badgeButton.y=-2;
    //iphone 6plus 手机
    CGFloat badgeX=0;
    if(ScreenWidth>375){
        badgeX=self.width-self.badgeButton.width-20;
    }else if(ScreenWidth>320){  //iPhone 6
        badgeX=self.width-self.badgeButton.width-15;
    }else{   //iphone 4-5s的宽度
        badgeX=self.width-self.badgeButton.width-10;
    }
    
    
    self.badgeButton.x=badgeX;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //设置按钮的颜色
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    //添加提醒数字按钮
    self.badgeButton.badgeValue = self.item.badgeValue;
    self.badgeButton.y = 0;
    
    CGFloat badgeX = 0;
    if(ScreenWidth>375){
        badgeX = self.width - self.badgeButton.width - 20;
    }else if(ScreenWidth>320){  //iPhone 6
        badgeX = self.width - self.badgeButton.width - 15;
    }else{   //iphone 4-5s的宽度
        badgeX = self.width - self.badgeButton.width - 10;
    }
    
    self.badgeButton.x = badgeX;
}

-(void)dealloc
{
    //   [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}


@end
