//
//  MessageFrameModel.m
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "MessageFrameModel.h"
#import "MessageModel.h"

#define headIconW 40;
#define contentFont [UIFont systemFontOfSize:15]
#define ContentEdgeInsets 20
#define MarginLeft 10

@implementation MessageFrameModel

//根据模型设置frame
- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    //1.设置时间
    if (messageModel.isHiddenTime == NO) {
        CGSize timeSize = [messageModel.time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGFloat timeY = 0;
        CGFloat timeH = 30;
        CGFloat timeW = timeSize.width + ContentEdgeInsets;
        CGFloat timeX = (ScreenWidth - timeW) * 0.5;
        
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    //2.设置头像
    CGFloat iconW = headIconW;
    CGFloat iconH = iconW;
    CGFloat iconX = 0;
    CGFloat iconY = CGRectGetMaxY(self.timeFrame) + MarginLeft;

    if (messageModel.isOwner) {    //如果是自己
        iconX = ScreenWidth - iconW - MarginLeft;
    }
    else {
        iconX = MarginLeft;
    }
    _headFrame = CGRectMake(iconX, iconY, iconW, iconH);
    //3.设置聊天内容
    CGSize contentSize = CGSizeMake(200, MAXFLOAT);
    CGRect contentRect;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:messageModel.attributedBody];
    contentRect = [text boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGFloat contentW = contentRect.size.width + 2 * ContentEdgeInsets;
    CGFloat contentH = contentRect.size.height + 2 * ContentEdgeInsets;
    CGFloat contentY = iconY - 2;
    CGFloat contentX = 0;
    if (messageModel.isOwner) {
        contentX = iconX - contentW - MarginLeft;
    }
    else {
        contentX = CGRectGetMaxX(_headFrame) + MarginLeft;
    }
    _contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
    //4.设置单元格的高度
    CGFloat maxIconY = CGRectGetMaxY(_headFrame);
    CGFloat maxContentY = CGRectGetMaxY(_contentFrame);
    
    _cellHeight = MAX(maxIconY,maxContentY) + MarginLeft;
    //5.设置聊天单元view的frame
    _chatFrame = CGRectMake(0, 0, ScreenWidth, _cellHeight);
}

@end
