//
//  GroupTableModel.h
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupTableModel : NSObject

@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *footer;
@property (nonatomic,strong) NSArray *items;  //里面存储TableCellItem

@end
