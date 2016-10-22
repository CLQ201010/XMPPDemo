//
//  SubscribeOperation.h
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeOperation : NSObject
SingletonH(Subscribe)

- (BOOL)addUser:(XMPPJID *)jid;
- (void)clear;

@property (nonatomic,strong) NSMutableArray *datas;

@end
