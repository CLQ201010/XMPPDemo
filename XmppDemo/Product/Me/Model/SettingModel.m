//
//  SettingModel.m
//  XmppDemo
//
//  Created by clq on 16/1/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

+ (instancetype)settingWithTile:(NSString *)title detailTitle:(NSString *)detailTile vcClass:(Class)vcClass option:(MyBlock)option
{
    SettingModel *settingModel = [[SettingModel alloc] init];
    settingModel.title = title;
    settingModel.detailTitle = detailTile;
    settingModel.vcClass = vcClass;
    settingModel.option = option;
    
    return settingModel;
}

@end
