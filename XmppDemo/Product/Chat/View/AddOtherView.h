//
//  AddOtherView.h
//  XmppDemo
//
//  Created by ccq chen on 16/10/20.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddOtherView;

typedef enum{
    AddButtonTypePhoto,  //图片按钮
    AddButtonTypeCamera, //拍摄按钮
    AddButtonTypeVideo,  //视频按钮
    AddButtonTypeLocation  //地图按钮
}AddButtonType;

@protocol AddOtherViewDelegate <NSObject>

@optional
- (void)addOtherView:(AddOtherView *)addOtherView buttonTag:(AddButtonType)buttonTag;

@end


@interface AddOtherView : UIView

@property (nonatomic, weak) id<AddOtherViewDelegate>delegate;

+ (instancetype)defaultView;

@end
