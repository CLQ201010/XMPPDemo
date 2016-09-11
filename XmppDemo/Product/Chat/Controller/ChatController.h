//
//  ChatController.h
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContacterModel;

@interface ChatController : UIViewController

@property (nonatomic,strong) ContacterModel *contacterModel;
@property (nonatomic,weak) UIImage *photoImg;

@end
