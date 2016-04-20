//
//  SettingViewCell.h
//  XmppDemo
//
//  Created by clq on 16/1/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingModel;

@interface SettingViewCell : UITableViewCell

@property (nonatomic,assign) SettingModel *settingModel; //传递给view

+ (instancetype)cellWithTableView:(UITableView *)table identifier:(NSString *)identifier;

@end
