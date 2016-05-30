//
//  NewFriendTableViewCell.h
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewFriendModelFrame;

@interface NewFriendTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic,weak) NewFriendModelFrame *friendModelFrame;

@end
