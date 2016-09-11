//
//  ContacterOperation.m
//  XmppDemo
//
//  Created by ccq chen on 16/9/10.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ContacterOperation.h"

@interface ContacterOperation ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ContacterOperation
SingletonM(contacter);

- (void)addItem:(NSXMLElement *)item
{
    NSString* jidStr = [[item attributeForName:@"jid"] stringValue];
    [self.datas addObject:jidStr];
}

- (void)clear
{
    [self.datas removeAllObjects];
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    
    return _datas;
}

@end
