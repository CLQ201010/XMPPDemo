//
//  ContacterTableCell.h
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContacterModel;

@interface ContacterTableCell : UITableViewCell

@property (nonatomic,weak) ContacterModel *contacterModel;

+ (instancetype)cellWithTablevView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
