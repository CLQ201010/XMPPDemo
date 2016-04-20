//
//  XHEmotionManager.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHEmotion.h"

#define kXHGifEmotionImageViewSize 60
#define kXHGifEmotionMinimumLineSpacing 12
#define kXHGifEmotionTopSpacing 12

#define kXHImgEmotionImageViewSize 40
#define kXHImgEmotionMinimumLineSpacing 8
#define kXHImgEmotionTopSpacing 2

#define kXHDelImage @"titleicon_18"

typedef NS_ENUM(NSInteger, EmotionType) {
    EmotionTypeImg,
    EmotionTypeGif,
};

@interface XHEmotionManager : NSObject

@property (nonatomic, copy) NSString *emotionName;
@property (nonatomic, strong) UIImage *emotionImg;
@property (nonatomic, assign) EmotionType emotionType;
/**
 *  某一类表情的数据源
 */
@property (nonatomic, strong) NSMutableArray *emotions;

@end
