//
//  AddFriendModelFrame.m
//  XmppDemo
//
//  Created by clq on 16/5/17.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "AddFriendModelFrame.h"

#define marginLeft 20
#define headWidth  30
#define headHeight headWidth

@implementation AddFriendModelFrame

- (void)setAddFriendModel:(AddFriendModel *)addFriendModel
{
    _addFriendModel = addFriendModel;
    
    //1.设置head
    CGFloat headY = 7;
    _headFrame = CGRectMake(marginLeft, headY, headWidth, headHeight);
    
    //2.设置标题
    CGFloat titleX = CGRectGetMaxX(_headFrame) + marginLeft;
    CGFloat titleY = 7;
    CGSize titleSize = [_addFriendModel.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _titleFrame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    //3.设置副标题
    CGFloat subTitleX = titleX;
    CGFloat subTitleY = CGRectGetMaxY(_titleFrame) + 2;
    CGSize subSize = [_addFriendModel.subTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    _subTitleFrame = CGRectMake(subTitleX, subTitleY, subSize.width, subSize.height);
}

@end
