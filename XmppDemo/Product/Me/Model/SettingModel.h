//
//  SettingModel.h
//  XmppDemo
//
//  Created by clq on 16/1/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MyBlock)();

@interface SettingModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detailTitle;

@property (nonatomic,assign) BOOL isLoginOut;
@property (nonatomic,copy) MyBlock option;
@property (nonatomic,strong) Class vcClass;

+ (instancetype)settingWithTile:(NSString *)title detailTitle:(NSString *)detailTile vcClass:(Class) vcClass option:(MyBlock)option;

@end
