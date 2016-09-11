//
//  ContacterModel.m
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ContacterModel.h"

@implementation ContacterModel

- (instancetype)initWithUserCoreData:(XMPPUserCoreDataStorageObject *)userCoreData
{
    self = [super init];
    if (self) {
        self.jid = userCoreData.jid;
        self.name = userCoreData.jid.user;
        self.nickname = userCoreData.nickname;
        self.photo = userCoreData.photo;
        self.userStatus = userCoreData.sectionNum.integerValue;
    }
    
    return self;
}

@end
