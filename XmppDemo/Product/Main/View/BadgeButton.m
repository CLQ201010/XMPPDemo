//
//  BadgeButton.m
//  XmppDemo
//
//  Created by clq on 16/1/14.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "BadgeButton.h"


@implementation BadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setBackgroundImage:[UIImage resizedImage:@"tabbar_badge"] forState:UIControlStateNormal];
        
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    if (badgeValue && ![badgeValue isEqualToString:@"0"]) {
        self.hidden = NO;
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        //如果是两位数
        if(badgeValue.length > 1) {
            CGSize btnSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
            
            self.width = btnSize.width + 20;
            self.height = self.currentBackgroundImage.size.height;
        }
        else {
            self.width = self.currentBackgroundImage.size.width;
            self.height = self.currentBackgroundImage.size.height;
        }
    }
    else {
        self.hidden = YES;
    }
    
}

@end
