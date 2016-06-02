//
//  AddFriendTableCell.m
//  XmppDemo
//
//  Created by clq on 16/1/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "AddFriendTableCell.h"
#import "AddFriendView.h"
#import "AddFriendModelFrame.h"

@interface AddFriendTableCell ()

@property (nonatomic,weak) AddFriendView *addFriendView;

@end

@implementation AddFriendTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    AddFriendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddFriendTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

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
    AddFriendView *addView = [[AddFriendView alloc] initWithFrame:self.frame];
    [self.contentView addSubview:addView];
    
    _addFriendView = addView;
}

- (void)setAddFriendModelFrame:(AddFriendModelFrame *)addFriendModelFrame
{
    _addFriendModelFrame = addFriendModelFrame;
    self.addFriendView.addFriendModelFrame = addFriendModelFrame;  //传递给view
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

@end
