//
//  TableCellModel.m
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "TableCellModel.h"

@implementation TableCellModel

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle vcClass:(Class)vcClass
{
    TableCellModel *item = [[TableCellModel alloc] init];
    item.title = title;
    item.detailTitle = detailTitle;
    item.icon = icon;
    item.vcClass = vcClass;
    
    return item;
}

@end
