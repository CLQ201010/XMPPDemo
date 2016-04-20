//
//  TREmotionModule.h
//  TRPet
//
//  Created by wyr on 15/5/1.
//  Copyright (c) 2015年 taro. All rights reserved.
//

#import <Foundation/Foundation.h>
// 表情
#define EMOTIONS_PERROW                                      7
#define EMOTIONS_ROWS                                        3


@interface TREmotionModule : NSObject

+(TREmotionModule *)sharedModule;

@property (nonatomic, strong, readonly) NSMutableArray *emotionBlocks;

// 全局页数
-(void)updatePageControl:(UIPageControl *)control withPageIndex:(NSUInteger)pageIndex;

// 如果需要单击pageControl：获取当前block的pageIndex + pageControl.currentPage


// 每个模块对应的起始页数: 单击模块按钮跳转scrollview
-(NSUInteger)pageIndexOfBlock:(NSUInteger)blockIndex;

// 当前页数对应的模块 滑动页数更新模块按钮
-(NSUInteger)blockIndexOfPage:(NSUInteger)pageIndex;

// 点击emoji按钮获取图片的url
-(NSString *)urlForTag:(NSUInteger)tag;

@end
