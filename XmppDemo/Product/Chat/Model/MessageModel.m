//
//  ChatMessageModel.m
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "MessageModel.h"
#import "RegexKitLite.h"
#import "HMRegexResult.h"
#import "HMEmotionAttachment.h"
#import "HMEmotionTool.h"

@implementation MessageModel

- (void)setBody:(NSString *)body
{
    _body = [body copy];
    [self createAttributedText];
}

- (NSArray *)regexResultsWithText:(NSString *)text
{
    //用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    //匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *regexResult = [[HMRegexResult alloc] init];
        regexResult.string = *capturedStrings;
        regexResult.range = *capturedRanges;
        regexResult.emotion = YES;
        [regexResults addObject:regexResult];
    }];
    
    //匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *regexResult = [[HMRegexResult alloc] init];
        regexResult.string = *capturedStrings;
        regexResult.range = *capturedRanges;
        regexResult.emotion = NO;
        [regexResults addObject:regexResult];
    }];
    
    //排序
    [regexResults sortUsingComparator:^NSComparisonResult(HMRegexResult *rr1, HMRegexResult *rr2) {
        NSUInteger loc1 = rr1.range.location;
        NSUInteger loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    
    return regexResults;
}

- (void)createAttributedText
{
    if (self.body == nil) {
        return;
    }
    
    self.attributedBody = [self attributedStringWithText:self.body];
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    //1.字符串匹配
    NSArray *regexResults = [self regexResultsWithText:text];
    
    //2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [regexResults enumerateObjectsUsingBlock:^(HMRegexResult *result, NSUInteger idx, BOOL * _Nonnull stop) {
        HMEmotion *emotion = nil;
        if (result.isEmotion) {
            emotion = [HMEmotionTool emotionWithDesc:result.string];
        }
        
        //有表情，拼接成富文本
        if (emotion) {
            //创建附件对象
            HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];
            
            //添加表情
            attach.emotion = emotion;
            UIFont *font = [UIFont systemFontOfSize:16];
            CGFloat lineHeight = font.lineHeight;
            attach.bounds = CGRectMake(0, -3, lineHeight, lineHeight);
            
            //将复建包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        }
        else { //不包含表情，拼接成普通文本
            NSMutableAttributedString *subStr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
            [attributedString appendAttributedString:subStr];
        }
    }];
    
    //设置字体
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

//设置时间
- (NSString *)time
{
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss Z";
    
    fmt.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"UTC"];
    NSDate *creatDate=[fmt dateFromString:_time];
    
    //判断是否为今年
    if (creatDate.isThisYear) //今年
    {
        if (creatDate.isToday)
        {
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:creatDate];
        }
        else if(creatDate.isYesterday) //昨天发的
        {
            fmt.dateFormat=@"昨天 HH:mm";
            return [fmt stringFromDate:creatDate];
        }
        else //至少是前天发布的
        {
            fmt.dateFormat=@"yyyy-MM-dd HH:mm";
            return [fmt stringFromDate:creatDate];
        }
    }
    else           //  往年
    {
        fmt.dateFormat=@"yyyy-MM-dd";
        return [fmt stringFromDate:creatDate];
    }
    
    return [fmt stringFromDate:creatDate];
}


@end
