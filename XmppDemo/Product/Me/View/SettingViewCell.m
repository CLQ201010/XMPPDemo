//
//  SettingViewCell.m
//  XmppDemo
//
//  Created by clq on 16/1/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "SettingViewCell.h"
#import "SettingModel.h"
#import "SettingView.h"

@interface SettingViewCell ()

@property (nonatomic,weak) SettingView *settingView;

@end

@implementation SettingViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    SettingView *settingView = [[SettingView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:settingView];
    
    self.settingView = settingView;
}

- (void)setSettingModel:(SettingModel *)settingModel
{
    _settingModel = settingModel;
    self.settingView.settingModel = settingModel;
}

+ (instancetype)cellWithTableView:(UITableView *)table identifier:(NSString *)identifier
{
    SettingViewCell *cell = [table dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SettingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

@end
