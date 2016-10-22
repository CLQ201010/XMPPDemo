//
//  ContacterOperation.h
//  XmppDemo
//
//  Created by ccq chen on 16/9/10.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContacterOperation : NSObject
SingletonH(contacter);

- (void)addItem:(NSXMLElement *)item;
- (void)clear;

@end
