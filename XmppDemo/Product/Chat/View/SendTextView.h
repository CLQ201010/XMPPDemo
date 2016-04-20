//
//  SendTextView.h
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMEmotion;

@interface SendTextView : UITextView

//拼接表情到最后面
- (void)appendEmotion:(HMEmotion *)emotion;
//具体的文字内容
- (NSString *)realText;
@end
