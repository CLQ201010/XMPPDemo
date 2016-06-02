//
//  BaseTableCell.m
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "BaseTableCell.h"
#import "BaseView.h"

@interface BaseTableCell ()

@property (nonatomic,weak) BaseView *baseView;

@end

@implementation BaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    BaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BaseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)setupUI
{
    BaseView *baseView = [[BaseView alloc] initWithFrame:self.bounds];
    self.baseView = baseView;
    [self.contentView addSubview:baseView];
}

- (void)setItem:(TableCellModel *)item
{
    _item = item;
    self.baseView.item = item;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

@end
