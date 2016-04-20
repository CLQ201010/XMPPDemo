//
//  TableCellModel.h
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Myblock)();

@interface TableCellModel : NSObject

@property (nonatomic,copy) NSString *icon;  //图标
@property (nonatomic,copy) NSString *title; //标题
@property (nonatomic,copy) NSString *detailTitle; //子标题
@property (nonatomic,strong) NSData *imageData;  //图片二进制文件

@property (nonatomic,copy) Myblock option;  //操作
@property (nonatomic,strong) Class vcClass;

+(instancetype)itemWithIcon:(NSString*)icon title:(NSString*)title detailTitle:(NSString*)detailTitle vcClass:(Class)vcClass;

@end
