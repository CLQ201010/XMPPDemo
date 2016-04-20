//
//  ChatViewCell.h
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrameModel;
@interface ChatViewCell : UITableViewCell

@property (nonatomic,strong) MessageFrameModel *messageFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
