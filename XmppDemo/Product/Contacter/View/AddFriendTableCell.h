//
//  AddFriendTableCell.h
//  XmppDemo
//
//  Created by clq on 16/1/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddFriendModelFrame;

@interface AddFriendTableCell : UITableViewCell

@property (nonatomic,strong) AddFriendModelFrame *addFriendModelFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
