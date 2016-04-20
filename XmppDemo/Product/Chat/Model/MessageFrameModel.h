//
//  MessageFrameModel.h
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageModel;

@interface MessageFrameModel : NSObject

@property (nonatomic,strong) MessageModel *messageModel;
//时间的frame
@property (nonatomic,assign,readonly) CGRect timeFrame;
//头像的frame
@property (nonatomic,assign,readonly) CGRect headFrame;
//内容的frame
@property (nonatomic,assign,readonly) CGRect contentFrame;
//单元格的高度
@property (nonatomic,assign,readonly) CGFloat cellHeight;
//聊天单元的frame
@property (nonatomic,assign,readonly) CGRect chatFrame;

@end
