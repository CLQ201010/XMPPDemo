//
//  Emotion.h
//  TRPet
//
//  Created by lijinchao on 15/8/4.
//  Copyright (c) 2015年 taro. All rights reserved.
//

#ifndef TRPet_Emotion_h
#define TRPet_Emotion_h

#import "XHEmotion.h"
#import "XHEmotionManager.h"

#define keyboardViewHeight  216.0

@protocol XHEmotionManagerViewDelegate <NSObject>

@optional
/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emotion   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
- (void)didSelecteEmotion:(XHEmotion *)emotion emotionType:(EmotionType)emotionType atIndexPath:(NSIndexPath *)indexPath;

- (void)didClickDelete;

- (void)didSend;

@end


@protocol XHEmotionManagerViewDataSource <NSObject>

@required
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column;

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
- (NSArray *)emotionManagersAtManager;

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfEmotionManagers;

@end


@interface EmotionControl : NSObject

-(instancetype)init:(CGRect)frame;
- (void)setup:(BOOL)showGif withSend:(BOOL)showSend;
- (void)setDelegate:(id<XHEmotionManagerViewDelegate>)delegate;
- (void)setDataSource:(id<XHEmotionManagerViewDataSource>)dataSource;
- (void)showEmotionTo:(UIView*)view;

- (void)reloadData;


@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGRect frame;

-(void)moveTo:(CGFloat)Y;
@end


#endif
