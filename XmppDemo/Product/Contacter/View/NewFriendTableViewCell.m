//
//  NewFriendTableViewCell.m
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NewFriendTableViewCell.h"
#import "NewFriendModelFrame.h"
#import "NewFriendView.h"

@interface NewFriendTableViewCell ()

@property (nonatomic,weak) NewFriendView *friendView;

@end

@implementation NewFriendTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[NewFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    NewFriendView *friendView = [[NewFriendView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:friendView];
    
    self.friendView = friendView;
}

- (void)setFriendModelFrame:(NewFriendModelFrame *)friendModelFrame
{
    _friendModelFrame = friendModelFrame;
    self.friendView.friendModelFrame = friendModelFrame;
}

@end
