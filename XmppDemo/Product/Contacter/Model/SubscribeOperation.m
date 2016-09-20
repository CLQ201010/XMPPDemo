//
//  SubscribeOperation.m
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "SubscribeOperation.h"

@implementation SubscribeOperation
SingletonM(Subscribe)

- (NSMutableArray *)datas
{
    if (_datas == nil)
    {
        _datas = [[NSMutableArray alloc] init];
    }
    
    return _datas;
}

- (BOOL)addUser:(XMPPJID *)jid
{
    if ([self.datas indexOfObject:jid] == NSNotFound)
    {
        [self.datas addObject:jid];
        return YES;
    }
    
    return NO;
}

- (void)clear
{
    [self.datas removeAllObjects];
}

@end
