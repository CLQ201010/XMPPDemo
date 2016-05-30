//
//  NewFriendModelFrame.m
//  XmppDemo
//
//  Created by clq on 16/5/30.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NewFriendModelFrame.h"

@implementation NewFriendModelFrame

- (void)setFriendModel:(NewFriendModel *)friendModel
{
    _friendModel = friendModel;
    
    //1.设置头像
    _iconFrame = CGRectMake(15, 10, 30, 30);
    
    //2.设置名称
    CGFloat nameX = CGRectGetMaxX(_iconFrame) + 8;
    CGFloat nameY = 7;
    CGSize titleSize = [_friendModel.jid.user sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    _nameFrame = CGRectMake(nameX, nameY, titleSize.width, titleSize.height);
    
    //3.设置说明信息
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_nameFrame) + 2;
    CGSize contentSize = [_friendModel.content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _contentFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    //4.接受按钮
    CGSize acceptBtnSize = [_friendModel.acceptBtn sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGFloat acceptBtnW = acceptBtnSize.width + 15;
    CGFloat acceptBtnH = acceptBtnSize.height + 10;
    CGFloat acceptBtnX = ScreenWidth - acceptBtnW - 15;
    CGFloat acceptBtnY = 12;
    _acceptBtnFrame = CGRectMake(acceptBtnX, acceptBtnY, acceptBtnW, acceptBtnH);
    
    //5.拒绝按钮
    CGSize rejectBtnSize = [_friendModel.rejectBtn sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGFloat rejectBtnW = rejectBtnSize.width + 15;
    CGFloat rejectBtnH = rejectBtnSize.height + 10;
    CGFloat rejectBtnX = acceptBtnX - rejectBtnW - 8;
    CGFloat rejectBtnY = 12;
    _rejectBtnFrame = CGRectMake(rejectBtnX, rejectBtnY, rejectBtnW, rejectBtnH);
}

@end
