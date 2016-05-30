//
//  NewFriendModelFrame.h
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFriendModel.h"

@interface NewFriendModelFrame : NSObject

@property (nonatomic,strong) NewFriendModel *friendModel;

@property (nonatomic,assign,readonly) CGRect nameFrame;
@property (nonatomic,assign,readonly) CGRect contentFrame;
@property (nonatomic,assign,readonly) CGRect iconFrame;
@property (nonatomic,assign,readonly) CGRect acceptBtnFrame;
@property (nonatomic,assign,readonly) CGRect rejectBtnFrame;

@end
