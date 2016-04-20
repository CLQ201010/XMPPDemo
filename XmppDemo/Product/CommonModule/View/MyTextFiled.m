//
//  MyTextFiled.m
//  XmppDemo
//
//  Created by clq on 16/1/15.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "MyTextFiled.h"

@interface MyTextFiled ()

@property (nonatomic,weak) UIImageView *imgView;

@end

@implementation MyTextFiled

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:13];
    }
    
    return self;
}

- (void)setCustomPlaceholder:(NSString *)customPlaceholder
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor grayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:customPlaceholder attributes:dic];
}

- (void)setImage:(NSString *)image
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 10, 30, 30);
    imgView.image = [UIImage imageNamed:image];
    
    self.leftViewMode = UITextFieldViewModeAlways; //总是显示
    self.leftView = imgView;
    self.imgView = imgView;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, 10, 30, 0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(0, 0, 30, 30);
}

@end
