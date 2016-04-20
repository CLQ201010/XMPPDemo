//
//  BaseView.m
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "BaseView.h"
#import "TableCellModel.h"

#define iconWidth 30
#define iconHeight iconWidth
#define marginLeft 20

@interface BaseView ()

@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *titleLbl;
@property (nonatomic,weak) UILabel *detailTitleLbl;
@property (nonatomic,weak) UIButton *arrowBtn;

@end

@implementation BaseView

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
    //1.添加图标
    UIImageView *iconView = [[UIImageView alloc] init];
    CGFloat iconY = 7;
    iconView.frame = CGRectMake(marginLeft, iconY, iconWidth, iconHeight);
    [self addSubview:iconView];
    self.iconView = iconView;
    //2.添加标题
    UILabel *titleLbl = [[UILabel alloc] init];
    CGFloat titleX = CGRectGetMaxX(iconView.frame) + marginLeft * 0.5;
    titleLbl.frame = CGRectMake(titleX, 7, 200, iconHeight);
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textColor = [UIColor blackColor];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    //3.添加详细标题
    UILabel *detailTitleLbl = [[UILabel alloc] init];
    detailTitleLbl.textColor = [UIColor lightGrayColor];
    detailTitleLbl.font = [UIFont systemFontOfSize:15];
    detailTitleLbl.hidden = YES;
    [self addSubview:detailTitleLbl];
    self.detailTitleLbl = detailTitleLbl;
    //4.添加箭头
    UIButton *arrowBtn = [[UIButton alloc] init];
    CGFloat arrowBtnW = 20;
    CGFloat arrowBtnH = arrowBtnW;
    CGFloat arrowBtnY = (self.height - arrowBtnH) * 0.5;
    CGFloat arrowBtnX = ScreenWidth - arrowBtnW - marginLeft;
    arrowBtn.frame = CGRectMake(arrowBtnX, arrowBtnY, arrowBtnW, arrowBtnH);
    arrowBtn.userInteractionEnabled = NO;
    [arrowBtn setImage:[UIImage resizedImage:@"common_arrow_right"] forState:UIControlStateNormal];
    [self addSubview:arrowBtn];
    self.arrowBtn = arrowBtn;
}

- (void)setItem:(TableCellModel *)item
{
    _item = item;
    //1.设置头像
    if(item.imageData){
        self.iconView.layer.cornerRadius=5;
        self.iconView.layer.borderWidth=0.5;
        self.iconView.layer.borderColor=[UIColor grayColor].CGColor;
        self.iconView.image=[UIImage imageWithData:item.imageData];
    }else{
        self.iconView.image=[UIImage imageNamed:item.icon];
    }
    
    //2.设置title
    self.titleLbl.text=item.title;
    //3.设置详细标题
    if(item.detailTitle){
        self.detailTitleLbl.hidden=NO;
        CGSize detailS=[item.detailTitle sizeWithAttributes:@{NSFontAttributeName:MyFont(15)}];
        CGFloat detailW=detailS.width;
        CGFloat detailH=detailS.height;
        CGFloat detailY=(self.height-detailH)*0.5;
        CGFloat detailX=ScreenWidth-detailW-self.arrowBtn.width-marginLeft;
        self.detailTitleLbl.frame=CGRectMake(detailX, detailY, detailW, detailH);
        self.detailTitleLbl.text=item.detailTitle;
    }
    
}

@end
