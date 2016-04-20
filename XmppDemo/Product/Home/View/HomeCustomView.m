//
//  HomeCustomView.m
//  XmppDemo
//
//  Created by clq on 16/1/26.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "HomeCustomView.h"
#import "HomeModel.h"
#import "BadgeButton.h"

#define MarginLeft 10
#define headWidth 40
#define headHeight headWidth

@interface HomeCustomView ()
//1.头像
@property (nonatomic,weak) UIImageView *headImgView;
//2.名称
@property (nonatomic,weak) UILabel *titleLbl;
//3.内容
@property (nonatomic,weak) UILabel *subTitleLbl;
//4.时间
@property (nonatomic,weak) UILabel *timeLbl;
//5.数字提醒按钮
@property (nonatomic,weak) BadgeButton *badgeBtn;

@end

@implementation HomeCustomView

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
    //1.头像
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.frame = CGRectMake(MarginLeft, MarginLeft,headWidth, headHeight);
    headImgView.layer.cornerRadius = 5;
    [self addSubview:headImgView];
    self.headImgView = headImgView;
    //2.名称
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textColor = [UIColor blackColor];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    //3.内容
    UILabel *subTitleLbl = [[UILabel alloc] init];
    subTitleLbl.font = [UIFont systemFontOfSize:14];
    subTitleLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:subTitleLbl];
    self.subTitleLbl = subTitleLbl;
    //4.时间
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.font = [UIFont systemFontOfSize:12];
    timeLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:timeLbl];
    self.timeLbl = timeLbl;
    //5.数字提醒按钮
    BadgeButton *badgeBtn = [[BadgeButton alloc] init];
    [self addSubview:badgeBtn];
    self.badgeBtn = badgeBtn;
}

- (void)setHomeModel:(HomeModel *)homeModel
{
    _homeModel = homeModel;
    //1.设置头像
    if (homeModel.headerIcon != nil) {
        self.headImgView.image = [UIImage imageWithData:homeModel.headerIcon];
    }
    else {
        self.headImgView.image = [UIImage imageNamed:@"common_defaultProfile"];
    }
    //2.设置用户名
    CGFloat nameY = MarginLeft;
    CGFloat nameX = CGRectGetMaxX(self.headImgView.frame) + MarginLeft;
    NSString *uerName = nil;
    if(homeModel.username != nil) {
        uerName = homeModel.username;
    }
    else {
        uerName = homeModel.jid.user;
    }
    CGSize nameSize = [uerName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    self.titleLbl.frame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    self.titleLbl.text = uerName;

    
    //3.设置body聊天内容
    CGFloat bodyY = CGRectGetMaxY(self.titleLbl.frame);
    CGFloat bodyX = nameX;
    CGFloat bodyW = ScreenWidth - bodyX - MarginLeft*2;
    CGFloat bodyH = 20;
    self.subTitleLbl.frame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
    self.subTitleLbl.text = homeModel.body;
    //4.设置时间
    CGSize timeSize = [homeModel.time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGFloat timeY = MarginLeft;
    CGFloat timeX = ScreenWidth - timeSize.width - MarginLeft;
    self.timeLbl.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    self.timeLbl.text = homeModel.time;
    //5.设置提醒数字按钮
    if (homeModel.badgeValue.length > 0 && ![homeModel.badgeValue isEqualToString:@""]) {
        self.badgeBtn.badgeValue = homeModel.badgeValue;
        self.badgeBtn.hidden = NO;
        CGFloat badgeX = CGRectGetMaxX(self.headImgView.frame) - self.badgeBtn.width *0.5;
        CGFloat badgeY = 0;
        self.badgeBtn.x = badgeX;
        self.badgeBtn.y = badgeY;
    }
    else {
        self.badgeBtn.hidden = YES;
    }
}

@end
