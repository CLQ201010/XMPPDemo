//
//  AddOtherView.m
//  XmppDemo
//
//  Created by ccq chen on 16/10/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "AddOtherView.h"

@interface AddOtherView () {
    UIButton *_photoBtn;
    UIButton *_cameraBtn;
    UIButton *_videoBtn;
    UIButton *_locationBtn;
}

@end

@implementation AddOtherView

+ (instancetype)defaultView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 1.照片
    _photoBtn = [self createButtonWithFrame:CGRectMake(20, 20, 60, 60) image:@"chat_bottombtn_photo" tag:AddButtonTypePhoto];
    [self addSubview:_photoBtn];
    
    // 2.拍摄
    _cameraBtn = [self createButtonWithFrame:CGRectMake(100, 20, 60, 60) image:@"chat_bottombtn_camera" tag:AddButtonTypeCamera];
    [self addSubview:_cameraBtn];
    
    // 3.视频
    _videoBtn = [self createButtonWithFrame:CGRectMake(180, 20, 60, 60) image:@"chat_bottombtn_video" tag:AddButtonTypeVideo];
    [self addSubview:_videoBtn];
    
    // 4.定位
    _locationBtn  = [self createButtonWithFrame:CGRectMake(260, 20, 60, 60) image:@"chat_bottombtn_location" tag:AddButtonTypeLocation];
    [self addSubview:_locationBtn];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame image:(NSString *)image tag:(AddButtonType)tag
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return btn;
}

#pragma mark  按钮点击事件

- (void)btnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addOtherView:buttonTag:)]) {
        [self.delegate addOtherView:self buttonTag:(AddButtonType)sender.tag];
    }
}


@end
