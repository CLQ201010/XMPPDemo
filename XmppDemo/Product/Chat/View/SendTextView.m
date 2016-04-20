//
//  SendTextView.m
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "SendTextView.h"
#import "HMEmotion.h"
#import "HMEmotionAttachment.h"

@implementation SendTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.font = [UIFont systemFontOfSize:16];
    self.returnKeyType = UIReturnKeySend;
    self.enablesReturnKeyAutomatically = YES; //如果没有内容，发送按钮自动设置为不可用
}

- (void)appendEmotion:(HMEmotion *)emotion
{
    if (emotion.emoji) { //emoji表情
        [self insertText:emotion.emoji];
    }
    else { //图片表情
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        //1.创建一个带有图片表情的富文本
        HMEmotionAttachment *attatch = [[HMEmotionAttachment alloc] init];
        attatch.emotion = emotion;
        attatch.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attatch];
        
        //获取表情插入的位置
        NSUInteger index = self.selectedRange.location;
        [attributedText insertAttributedString:attachString atIndex:index];
        //设置属性文本字体

        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,attributedText.length)];
        self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(index + 1, 0);
        
        //需要重新设置字体，不然字体会变成12pt
       // self.font = [UIFont systemFontOfSize:16];
    }
}

- (NSString *)realText
{
    NSMutableString *str = [NSMutableString string];
    
    //遍历富文本里面的所有内容，将表情用其描述替代
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        HMEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach != nil) {
            [str appendString:attach.emotion.chs];
        }
        else {
            NSString *substr = [self.attributedText attributedSubstringFromRange:range].string;
            [str appendString:substr];
        }
        
    }];
    
    return str;
}

@end
