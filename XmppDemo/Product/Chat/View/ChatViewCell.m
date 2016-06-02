//
//  ChatViewCell.m
//  XmppDemo
//
//  Created by clq on 16/1/28.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ChatViewCell.h"
#import "MessageFrameModel.h"
#import "ChatCustomView.h"

@interface ChatViewCell ()

@property (nonatomic,weak) ChatCustomView *customView;

@end

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    ChatCustomView *custonView = [[ChatCustomView alloc] initWithFrame:self.bounds];
    
    [self.contentView addSubview:custonView];
    self.customView = custonView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)setMessageFrameModel:(MessageFrameModel *)messageFrameModel
{
    _messageFrameModel = messageFrameModel;
    self.customView.messageFrameModel = messageFrameModel;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

@end
