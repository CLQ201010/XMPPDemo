//
//  AddFriendView.m
//  XmppDemo
//
//  Created by clq on 16/1/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "AddFriendView.h"
#import "AddFriendModel.h"
#define marginLeft 20

@interface AddFriendView ()

@property (nonatomic,weak) UILabel *titleLbl;
@property (nonatomic,weak) UILabel *subTitleLbl;
@property (nonatomic,weak) UIImageView *iconImgView;
@property (nonatomic,weak) UIImageView *arrowImgView;

@end

@implementation AddFriendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    //1.初始化图标
    UIImageView *iconImgView = [[UIImageView alloc] init];
    [self addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    //2.初始化title
    UILabel *titleLbl = [[UILabel alloc] init];
    [titleLbl setTextColor:[UIColor colorWithRed:9/255.0 green:9/255.0 blue:9/255.0 alpha:1.0]];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    //3.初始化subTitle
    UILabel *subTitleLbl = [[UILabel alloc] init];
    [subTitleLbl setTextColor:[UIColor lightGrayColor]];
    subTitleLbl.font = [UIFont systemFontOfSize:10];
    subTitleLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:subTitleLbl];
    self.subTitleLbl = subTitleLbl;
    
    //4.初始化箭头
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    [self addSubview:arrowImgView];
    self.arrowImgView = arrowImgView;
}

- (void)setAddFriendModel:(AddFriendModel *)addFriendModel
{
    _addFriendModel = addFriendModel;
    //设置位置
}

@end
