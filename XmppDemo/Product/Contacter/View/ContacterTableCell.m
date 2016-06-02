//
//  ContacterTableCell.m
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ContacterTableCell.h"
#import "ContacterModel.h"
#import "ContacterView.h"

@interface ContacterTableCell ()

@property (nonatomic,weak) ContacterView *contacterView;

@end

@implementation ContacterTableCell

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
    ContacterView *contacterView = [[ContacterView alloc] initWithFrame:self.bounds];
    [self addSubview:contacterView];
    self.contacterView = contacterView;
}

+ (instancetype)cellWithTablevView:(UITableView *)tableView identifier:(NSString *)identifier
{
    ContacterTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (tableCell == nil) {
        tableCell = [[ContacterTableCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return tableCell;
}

- (void)setContacterModel:(ContacterModel *)contacterModel
{
    _contacterModel = contacterModel;
    self.contacterView.contacterModel = contacterModel;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

@end
