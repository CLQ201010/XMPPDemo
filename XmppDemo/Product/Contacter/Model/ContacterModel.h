//
//  ContacterModel.h
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContacterModel : NSObject

@property (nonatomic,strong) XMPPJID *jid;
@property (nonatomic,copy) NSString *name;   //用户名
@property (nonatomic,weak) UIImage *photo;  //用户头像
@property (nonatomic,copy) NSString *nickname;  //用户的昵称
@property (nonatomic,copy) NSString *pinyin;   //用户名拼音，用于排序搜索
//用户状态
@property (nonatomic,assign) NSInteger userStatus; //0:在线  1:离开  3:离线
@property (nonatomic,strong) Class vcClass; //记录要跳转的类

- (instancetype)initWithUserCoreData:(XMPPUserCoreDataStorageObject *)userCoreData;

@end
