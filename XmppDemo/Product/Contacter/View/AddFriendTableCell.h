//
//  AddFriendTableCell.h
//  XmppDemo
//
//  Created by clq on 16/1/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddFriendModel;

@interface AddFriendTableCell : UITableViewCell

@property (nonatomic,strong) AddFriendModel *addFriendModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
