//
//  NSString+Trim.h
//  XmppDemo
//
//  Created by clq on 16/1/17.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

+ (NSString *)Trim:(NSString *)str;  //去掉多余空格
+ (NSString *)hanziToPinyin:(NSString *)str; //汉字转拼音
+ (NSString *)cutXmppPre:(NSString *)str; //去掉@

@end
