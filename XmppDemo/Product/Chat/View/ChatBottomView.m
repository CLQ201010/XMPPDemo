//
//  ChatBottomView.m
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ChatBottomView.h"
#import "SendTextView.h"

#define MARGIN_CENTER 5
#define MARGIN_LEFT 2
#define BUTTON_WIDTH 35
#define BUTTON_HEIGHT BUTTON_WIDTH
#define INPUT_HEIGHT 36

@interface ChatBottomView ()

@property (nonatomic,weak) UIButton *audioBtn; //语音按钮
@property (nonatomic,weak) UIButton *faceBtn;  //表情按钮
@property (nonatomic,weak) UIButton *addBtn;   //添加图片按钮

@end

@implementation ChatBottomView

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
    //1.界面初始化
    self.width = ScreenWidth;
    self.height = BOTTOMVIEW_HEIGHT;
    self.backgroundColor = [UIColor whiteColor];
    //2.添加一条线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    //3.添加语音按钮
    UIButton *audioBtn = [self addButtonWithImage:@"chat_bottombtn_voice" imageHL:@"chat_bottombtn_voiceHL" tag:BottomButtonTypeAudio];
    self.audioBtn = audioBtn;
    //4.添加输入框
    SendTextView *sendTextView = [[SendTextView alloc] init];
    [self addSubview:sendTextView];
    self.sendTextView = sendTextView;
    //5.添加表情按钮
    UIButton *faceBtn = [self addButtonWithImage:@"chat_bottombtn_emotion" imageHL:@"chat_bottombtn_emotionHL" tag:BottomButtonTypeEmotion];
    self.faceBtn = faceBtn;
    //6.添加添加按钮
    UIButton *addBtn = [self addButtonWithImage:@"chat_bottombtn_add" imageHL:@"chat_bottombtn_addHL" tag:BottomButtonTypeAddPicture];
    self.addBtn = addBtn;
}

- (UIButton *)addButtonWithImage:(NSString *)image imageHL:(NSString *)imageHL tag:(BottomButtonType)tag
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage resizedImage:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizedImage:imageHL] forState:UIControlStateHighlighted];
    btn.tag = tag;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)buttonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(chatBottomView:buttonTag:)]) {
        [self.delegate chatBottomView:self buttonTag:(BottomButtonType)sender.tag];
    }
}

- (void)setAddStatus:(BOOL)addStatus
{
    _addStatus = addStatus;
    _emotionStatus = NO;
    
    if (addStatus) {
        [self.addBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_add"] forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_addHL"] forState:UIControlStateHighlighted];
    }
    else {
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_emotion"] forState:UIControlStateNormal];
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_emotionHL"] forState:UIControlStateHighlighted];
    }
}

- (void)setEmotionStatus:(BOOL)emotionStatus
{
    _emotionStatus = emotionStatus;
    _addStatus = NO;
    
    if (emotionStatus) {
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_keyboard"] forState:UIControlStateNormal];
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_keyboardHL"] forState:UIControlStateHighlighted];
    }
    else {
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_emotion"] forState:UIControlStateNormal];
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"chat_bottombtn_emotionHL"] forState:UIControlStateHighlighted];
    }
}

- (void)layoutSubviews
{
    [super subviews];
    CGFloat btnY = (self.height - BUTTON_HEIGHT) *0.5;
    
    //1.声音按钮
    CGFloat auidoX = MARGIN_LEFT;
    self.audioBtn.frame = CGRectMake(auidoX, btnY, BUTTON_WIDTH, BUTTON_HEIGHT);
    //2.输入框
    CGFloat sendW = ScreenWidth - (BUTTON_WIDTH+MARGIN_CENTER)*3 -  MARGIN_LEFT*2;
    CGFloat sendH = INPUT_HEIGHT;
    CGFloat sendX = CGRectGetMaxX(self.audioBtn.frame) + MARGIN_CENTER;
    CGFloat sendY = (self.height - INPUT_HEIGHT) * 0.5;
    self.sendTextView.frame = CGRectMake(sendX, sendY, sendW, sendH);
    //3.表情
    CGFloat faceX = CGRectGetMaxX(self.sendTextView.frame) + MARGIN_CENTER;
    self.faceBtn.frame = CGRectMake(faceX, btnY, BUTTON_WIDTH, BUTTON_HEIGHT);
    //4.添加图片
    CGFloat addX = CGRectGetMaxX(self.faceBtn.frame) + MARGIN_CENTER;
    self.addBtn.frame = CGRectMake(addX, btnY, BUTTON_WIDTH, BUTTON_HEIGHT);
}

@end
