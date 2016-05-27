//
//  AddFriendModelFrame.h
//  XmppDemo
//
//  Created by clq on 16/5/17.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddFriendModel.h"

@interface AddFriendModelFrame : NSObject

@property (nonatomic,assign,readonly) CGRect titleFrame;
@property (nonatomic,assign,readonly) CGRect subTitleFrame;
@property (nonatomic,assign,readonly) CGRect headFrame;

@property (nonatomic,strong) AddFriendModel *addFriendModel;

@end
