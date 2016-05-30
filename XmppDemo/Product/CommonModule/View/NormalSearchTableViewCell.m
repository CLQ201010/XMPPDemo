//
//  NormalSearchTableViewCell.m
//  XmppDemo
//
//  Created by clq on 16/5/27.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NormalSearchTableViewCell.h"
#import "UserSearchModel.h"
#import "NormalSearchView.h"

@interface NormalSearchTableViewCell ()

@property (nonatomic,weak) NormalSearchView *searchView;

@end

@implementation NormalSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    NormalSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[NormalSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setupUI
{
    NormalSearchView *searchView = [[NormalSearchView alloc] initWithFrame:self.bounds];
    self.searchView = searchView;
    [self.contentView addSubview:searchView];
}

- (void)setUserSearchModel:(UserSearchModel *)userSearchModel
{
    _userSearchModel = userSearchModel;
    self.searchView.userSearchModel = userSearchModel;
}

@end
