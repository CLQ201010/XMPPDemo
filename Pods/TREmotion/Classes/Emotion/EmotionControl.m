//
//  Emotion.m
//  TRPet
//
//  Created by lijinchao on 15/8/4.
//  Copyright (c) 2015年 taro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EmotionControl.h"

#import "TRKeyboardEmojiViewController.h"
#import "XHEmotionManagerView.h"

@interface EmotionControl ()

@property (nonatomic, strong) XHEmotionManagerView *emotionView;

@end

@implementation EmotionControl

-(instancetype)init:(CGRect)frame{
    self = [super init];
    if (self) {
        _frame = frame;
        _emotionView = [[XHEmotionManagerView alloc] initWithFrame:_frame];
        _emotionView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.0];
        _emotionView.alpha = 0.0;
    }
    return self;

}

-(void)dealloc{
    NSLog(@"EmotionControl dealloc");
}

- (void)setup:(BOOL)showGif withSend:(BOOL)showSend{
    [_emotionView setup:showGif withSend:showSend];
}


- (void)setDelegate:(id<XHEmotionManagerViewDelegate>)delegate{
    _emotionView.delegate = delegate;
}
- (void)setDataSource:(id<XHEmotionManagerViewDataSource>)dataSource{
    _emotionView.dataSource = dataSource;
}

- (void)showEmotionTo:(UIView*)view{
    [view addSubview:_emotionView];
    [view bringSubviewToFront:_emotionView];
}

- (void)reloadData{
    [_emotionView reloadData];
}

-(void)setAlpha:(CGFloat)alpha{
    _emotionView.alpha = alpha;
}

-(CGFloat)getAlpha{
    return _emotionView.alpha;
}

-(void)setFrame:(CGRect)frame{
    _emotionView.frame = frame;
}
-(CGRect)getFrame{
    return _emotionView.frame;
}

-(void)moveTo:(CGFloat)Y{
    [_emotionView moveTo:Y];
}

@end