//
//  NSString+Trim.m
//  XmppDemo
//
//  Created by clq on 16/1/17.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (NSString *)Trim:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}

+ (NSString *)hanziToPinyin:(NSString *)str
{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:str];
    
    if (CFStringTransform((__bridge CFMutableStringRef)mutableStr, 0, kCFStringTransformMandarinLatin, NO)) {

    }
    
    if (CFStringTransform((__bridge CFMutableStringRef)mutableStr, 0, kCFStringTransformStripDiacritics, NO)) {
        
    }
    
    
    return mutableStr;
}

+ (NSString *)cutXmppPre:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"@"];
    return array[0];
}

@end
