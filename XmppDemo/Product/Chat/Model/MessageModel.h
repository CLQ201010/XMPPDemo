//
//  ChatMessageModel.h
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString *body; //消息内容
@property (nonatomic,copy) NSAttributedString *attributedBody;

@property (nonatomic,copy) NSString *time; //消息的时间
@property (nonatomic,assign) BOOL isOwner; //是否是自己
@property (nonatomic,copy) NSString *from; // 谁发的消息
@property (nonatomic,copy) NSString *to; //发给谁
@property (nonatomic,assign) BOOL isHiddenTime; //是否隐藏时间

@property (nonatomic,weak) UIImage *otherPhoto; //聊天用户的头像
@property (nonatomic,strong) NSData *headImage;  //自己头像

@end
