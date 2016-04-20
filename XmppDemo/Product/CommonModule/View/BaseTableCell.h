//
//  BaseTableCell.h
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableCellModel;

@interface BaseTableCell : UITableViewCell

@property (nonatomic,strong) TableCellModel *item; //传递给自定义view

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
