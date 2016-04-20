//
//  XHEmotionSectionBar.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionSectionBar.h"

#define kXHStoreManagerItemWidth 80

@interface XHEmotionSectionBar ()




@property (nonatomic, weak) UIScrollView *sectionBarScrollView;
@property (nonatomic, weak) UIButton *storeManagerItemButton;

@end

@implementation XHEmotionSectionBar

- (void)sectionButtonClicked:(UIButton *)sender {
    
  
    
    if (sender == self.storeManagerItemButton) {
        if ([self.delegate respondsToSelector:@selector(didSend)]) {
            [self.delegate didSend];
        }
        return;
    }
    
    [[self.sectionBarScrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = obj;
        if (btn) {
            [btn setBackgroundColor:[UIColor blackColor]];
        }
    }];
    [sender setBackgroundColor:[UIColor colorWithRed:0xBF/255.0 green:0xBF/255.0 blue:0xBF/255.0 alpha:1.0]];
    
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotionManager:atSection:)]) {
        NSInteger section = sender.tag;
        if (section < self.emotionManagers.count) {
            [self.delegate didSelecteEmotionManager:[self.emotionManagers objectAtIndex:section] atSection:section];
        }
    }
}



- (UIButton *)cratedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor colorWithRed:0xD9/255.0 green:0xD9/255.0 blue:0xD9/255.0 alpha:1.0] CGColor];
    button.frame = CGRectMake(0, 0, kXHStoreManagerItemWidth, CGRectGetHeight(self.bounds));
    [button addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)reloadData {
    if (!self.emotionManagers.count)
        return;
    
    [self.sectionBarScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (XHEmotionManager *emotionManager in self.emotionManagers) {
        NSInteger index = [self.emotionManagers indexOfObject:emotionManager];
        UIButton *sectionButton = [self cratedButton];
        sectionButton.tag = index;
        if (emotionManager.emotionImg) {
            [sectionButton setImage:emotionManager.emotionImg forState:UIControlStateNormal];
        }else{
            [sectionButton setTitle:emotionManager.emotionName forState:UIControlStateNormal];
        }
        sectionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        CGRect sectionButtonFrame = sectionButton.frame;
        sectionButtonFrame.origin.x = index * (CGRectGetWidth(sectionButtonFrame));
        sectionButton.frame = sectionButtonFrame;
        
        
        [self.sectionBarScrollView addSubview:sectionButton];
    }
    
    [self.sectionBarScrollView setContentSize:CGSizeMake(self.emotionManagers.count * kXHStoreManagerItemWidth, CGRectGetHeight(self.bounds))];
}

#pragma mark - Lefy cycle

- (void)setup {
    if (!_sectionBarScrollView) {
        CGFloat scrollWidth = CGRectGetWidth(self.bounds);
        if (self.isShowEmotionStoreButton) {
            scrollWidth -= kXHStoreManagerItemWidth;
        }
        UIScrollView *sectionBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, CGRectGetHeight(self.bounds))];
        [sectionBarScrollView setScrollsToTop:NO];
        sectionBarScrollView.showsVerticalScrollIndicator = NO;
        sectionBarScrollView.showsHorizontalScrollIndicator = NO;
        sectionBarScrollView.pagingEnabled = NO;
        [self addSubview:sectionBarScrollView];
        _sectionBarScrollView = sectionBarScrollView;
    }
    
    if (!_storeManagerItemButton && self.isShowEmotionStoreButton) {
        UIButton *storeManagerItemButton = [self cratedButton];
        
        CGRect storeManagerItemButtonFrame = storeManagerItemButton.frame;
        storeManagerItemButtonFrame.origin.x = CGRectGetWidth(self.bounds) - kXHStoreManagerItemWidth;
        storeManagerItemButton.frame = storeManagerItemButtonFrame;
        
        [storeManagerItemButton setTitle:@"发送" forState:UIControlStateNormal];
        [storeManagerItemButton setTitleColor:[UIColor colorWithRed:0x94/255.0 green:0x94/255.0 blue:0x94/255.0 alpha:1.0] forState:UIControlStateNormal];
        [storeManagerItemButton setBackgroundColor:[UIColor colorWithRed:0xEB/255.0 green:0xEB/255.0 blue:0xEB/255.0 alpha:1.0]];
        [self addSubview:storeManagerItemButton];
        _storeManagerItemButton = storeManagerItemButton;
    }
}

- (void)setIsShowEmotionStoreButton:(BOOL)isShowEmotionStoreButton{
    _isShowEmotionStoreButton = isShowEmotionStoreButton;
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame showEmotionStoreButton:(BOOL)isShowEmotionStoreButtoned {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isShowEmotionStoreButton = isShowEmotionStoreButtoned;
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotionManagers = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
