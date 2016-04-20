//
//  EmotionViewController.h
//  EmojiKeyboardDemo
//
//  Created by wyr mini on 15/4/24.
//  Copyright (c) 2015年 wuyr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRKeyboardEmojiViewController;
@protocol TRKeyboardEmojiViewControllerDelegate <NSObject>

-(void)emojiViewController:(TRKeyboardEmojiViewController *)viewController didClickEmotion:(NSString *)emotionName;
-(void)emojiViewControllerDidClickDeleteButton;


@end


@interface TREmotionVO : NSObject
@property (nonatomic, strong) NSString* emotionUrl;
@property (nonatomic, assign) NSInteger emotionTag;
@end


@interface TRKeyboardEmojiViewController : UIViewController

@property (nonatomic, strong) id<TRKeyboardEmojiViewControllerDelegate> delegate;

-(void)setup;

-(void)moveTo:(CGFloat)Y;

@end
