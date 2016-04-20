//
//  ChatBottomView.h
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SendTextView;
@class ChatBottomView;

#define BOTTOMVIEW_HEIGHT 49

typedef enum{
    BottomButtonTypeEmotion,  //表情按钮
    BottomButtonTypeAddPicture, //图片按钮
    BottomButtonTypeAudio  //语音按钮
}BottomButtonType;

@protocol ChatBottomViewDelegate <NSObject>

@optional
- (void)chatBottomView:(ChatBottomView *)bottomView buttonTag:(BottomButtonType)buttonTag;

@end

@interface ChatBottomView : UIView

@property (nonatomic,weak) id<ChatBottomViewDelegate>delegate;
@property (nonatomic,weak) SendTextView *sendTextView;

@property (nonatomic,assign) BOOL emotionStatus; //表情按钮选中状态
@property (nonatomic,assign) BOOL addStatus;  //添加图片选中状态

@end
