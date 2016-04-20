//
//  ChatCustomView.m
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ChatCustomView.h"
#import "MessageFrameModel.h"
#import "MessageModel.h"

@interface ChatCustomView ()

@property (nonatomic,weak) UILabel *timeLbl;  //显示聊天时间
@property (nonatomic,weak) UIButton *timeBtn; //显示聊天时间
@property (nonatomic,weak) UIImageView *headImgView; //显示用户头像
@property (nonatomic,weak) UIButton *contentBtn;  //显示聊天内容

@end

@implementation ChatCustomView

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
    //1.设置聊天时间
    UIButton *timeBtn = [[UIButton alloc] init];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    timeBtn.titleLabel.textColor = [UIColor whiteColor];
    timeBtn.backgroundColor = [UIColor lightGrayColor];
    timeBtn.layer.masksToBounds = YES;
    timeBtn.layer.cornerRadius = 5;
    timeBtn.userInteractionEnabled = NO;

    [self addSubview:timeBtn];
    self.timeBtn = timeBtn;
    //2.设置用户头像
    UIImageView *headImgView = [[UIImageView alloc] init];
    [self addSubview:headImgView];
    self.headImgView = headImgView;
    //3.设置正文内容
    UIButton *contentBtn = [[UIButton alloc] init];
    contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    contentBtn.titleLabel.numberOfLines = 0; //多行显示
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 20);
    [self addSubview:contentBtn];
    self.contentBtn = contentBtn;
}

- (void)setMessageFrameModel:(MessageFrameModel *)messageFrameModel
{
    _messageFrameModel = messageFrameModel;
    
    MessageModel * messageModel = messageFrameModel.messageModel;
    
    //设置frame
    self.frame = messageFrameModel.chatFrame;
    //1.设置聊天时间
    self.timeBtn.frame = messageFrameModel.timeFrame;
    [self.timeBtn setTitle:messageModel.time forState:UIControlStateNormal];
    //2.设置用户头像
    self.headImgView.frame = messageFrameModel.headFrame;
    if (messageModel.isOwner) {
        UIImage *headImg = messageModel.headImage?[UIImage imageWithData:messageModel.headImage]:[UIImage imageNamed:@"me_icon_defaultuser"];
        self.headImgView.image = headImg;
    }
    else {
        self.headImgView.image = messageModel.otherPhoto?messageModel.otherPhoto:[UIImage imageNamed:@"common_icon_defaultuser"];
    }
    //3.设置内容
    self.contentBtn.frame = messageFrameModel.contentFrame;
    [self.contentBtn setAttributedTitle:messageModel.attributedBody forState:UIControlStateNormal];
    //4.设置聊天背景图片
    if (messageModel.isOwner) {
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"chat_text_send"] forState:UIControlStateNormal];
    }
    else {
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"chat_text_receive"] forState:UIControlStateNormal];
    }
    
}

@end
