//
//  NormalSearchTableViewCell.h
//  XmppDemo
//
//  Created by clq on 16/5/27.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserSearchModel;

@interface NormalSearchTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic,weak) UserSearchModel *userSearchModel;

@end
