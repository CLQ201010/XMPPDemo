//
//  SettingView.m
//  XmppDemo
//
//  Created by clq on 16/1/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "SettingView.h"
#import "SettingModel.h"

#define marginLeft 20

@interface SettingView ()

@property (nonatomic,weak) UILabel *titleLbl;
@property (nonatomic,weak) UILabel *detailTitleLbl;
@property (nonatomic,weak) UIButton *arrowBtn;

@end

@implementation SettingView

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
    //1.添加标题
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textColor = [UIColor blackColor];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    //2.添加副标题
    UILabel *detailTitleLbl = [[UILabel alloc] init];
    detailTitleLbl.font = [UIFont systemFontOfSize:15];
    detailTitleLbl.textColor = [UIColor lightGrayColor];
    detailTitleLbl.hidden = YES;
    [self addSubview:detailTitleLbl];
    self.detailTitleLbl = detailTitleLbl;
    //3.添加箭头
    UIButton *arrowBtn = [[UIButton alloc] init];
    
    CGFloat arrowBtnW = 20;
    CGFloat arrowBtnH = arrowBtnW;
    CGFloat arrowBtnX = ScreenWidth - marginLeft - arrowBtnW;
    CGFloat arrowBtnY = (self.height - arrowBtnH) * 0.5;
    
    arrowBtn.frame = CGRectMake(arrowBtnX, arrowBtnY, arrowBtnW, arrowBtnH);
    arrowBtn.userInteractionEnabled = NO;
    [arrowBtn setImage:[UIImage resizedImage:@"common_arrow_right"] forState:UIControlStateNormal];
    [self addSubview:arrowBtn];
    self.arrowBtn = arrowBtn;
}

- (void)setSettingModel:(SettingModel *)settingModel
{
    _settingModel = settingModel;
    //1.计算title的frame
    CGSize titleSize = [settingModel.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    CGFloat titleX;
    if (settingModel.isLoginOut) {
        titleX = (ScreenWidth - titleSize.width) * 0.5;
        self.arrowBtn.hidden = YES;
    }
    else {
        titleX = marginLeft;
    }
    CGFloat titleY = (self.height - titleSize.height) * 0.5;
    self.titleLbl.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    self.titleLbl.text = settingModel.title;
    //2.计算detailTitle的frame
    if (settingModel.detailTitle.length > 0) {
        self.detailTitleLbl.hidden = NO;
        CGSize detailSize = [settingModel.detailTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        CGFloat detailW = detailSize.width;
        CGFloat detailH = detailSize.height;
        CGFloat detailX = ScreenWidth - marginLeft - self.arrowBtn.width - detailW;
        CGFloat detailY = (self.height - detailH) * 0.5;
        self.detailTitleLbl.frame = CGRectMake(detailX, detailY, detailW, detailH);
        self.detailTitleLbl.text = settingModel.detailTitle;
    }
}


@end
