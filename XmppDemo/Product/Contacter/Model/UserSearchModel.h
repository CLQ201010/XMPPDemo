//
//  UserSearchModel.h
//  XmppDemo
//
//  Created by clq on 16/3/14.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSearchModel : NSObject

@property (nonatomic,copy) NSString *jidStr; //唯一标示
@property (nonatomic,copy) NSString *userName; //用户名称
@property (nonatomic,copy) NSString *nickName;  //用户昵称
@property (nonatomic,copy) NSString *email;   //邮箱地址
@property (nonatomic,assign) BOOL isAdded; //是否添加过了
@property (nonatomic,assign) BOOL isOwn; //是否是自己

@end
