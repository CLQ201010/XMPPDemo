//
//  XHEmotionManagerView.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//
#ifndef MessageKit_XHEmotionManagerView_H
#define MessageKit_XHEmotionManagerView_H

#import <UIKit/UIKit.h>
#import "EmotionControl.h"

#define kXHEmotionPageControlHeight 38
#define kXHEmotionSectionBarHeight 36


@interface XHEmotionManagerView : UIView<XHEmotionManagerViewDataSource>

@property (nonatomic, weak) id <XHEmotionManagerViewDelegate> delegate;

@property (nonatomic, weak) id <XHEmotionManagerViewDataSource> dataSource;

/**
 *  是否显示表情商店的按钮
 */
@property (nonatomic, assign) BOOL isShowEmotionStoreButton; // default is YES

/**
 *  根据数据源刷新UI布局和数据
 */
- (void)reloadData;
- (void)setup:(BOOL)showGif withSend:(BOOL)showSend;
- (void)moveTo:(CGFloat)Y;
@end



#endif
