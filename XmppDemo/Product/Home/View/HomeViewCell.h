//
//  HomeViewCell.h
//  XmppDemo
//
//  Created by clq on 16/1/26.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModel;

@interface HomeViewCell : UITableViewCell

@property (nonatomic,strong) HomeModel *homeModel;

+ (id)cellWithTableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier;

@end
