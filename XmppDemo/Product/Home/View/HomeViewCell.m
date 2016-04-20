//
//  HomeViewCell.m
//  XmppDemo
//
//  Created by clq on 16/1/26.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "HomeViewCell.h"
#import "HomeModel.h"
#import "HomeCustomView.H"

@interface HomeViewCell ()

@property (nonatomic,weak) HomeCustomView *customView;

@end

@implementation HomeViewCell


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
    HomeCustomView *customView = [[HomeCustomView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    [self.contentView addSubview:customView];
    self.customView = customView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier
{
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)setHomeModel:(HomeModel *)homeModel
{
    self.customView.homeModel = homeModel;
}

@end
