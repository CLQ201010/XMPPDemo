//
//  ContacterView.m
//  XmppDemo
//
//  Created by clq on 16/1/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ContacterView.h"
#import "ContacterModel.h"

#define headWidth  30
#define headHeight headWidth
#define marginLef 20

@interface ContacterView ()

@property (nonatomic,weak) UIImageView *headImgView;
@property (nonatomic,weak) UILabel *userNameLbl;

@end

@implementation ContacterView

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
    //1.添加头像
    UIImageView *headImgView = [[UIImageView alloc] init];
    CGFloat headY = 7;
    headImgView.frame = CGRectMake(marginLef, headY, headWidth, headHeight);
    [self addSubview:headImgView];
    self.headImgView = headImgView;
    
    //2.添加用户名
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.font = [UIFont systemFontOfSize:17];
    nameLbl.textColor = [UIColor blackColor];
    CGFloat nameX = CGRectGetMaxX(headImgView.frame) + marginLef;
    CGFloat nameY = 7;
    nameLbl.frame = CGRectMake(nameX, nameY, 250, headHeight);
    [self addSubview:nameLbl];
    self.userNameLbl = nameLbl;
    

}

- (void)setContacterModel:(ContacterModel *)contacterModel
{
    _contacterModel = contacterModel;
    self.headImgView.image = contacterModel.photo ? contacterModel.photo : [UIImage imageNamed:@"common_defaultProfile"];
    if (contacterModel.nickname == nil) {
        self.userNameLbl.text = contacterModel.name;
    }
    else {
        self.userNameLbl.text = contacterModel.nickname;
    }
}

@end
