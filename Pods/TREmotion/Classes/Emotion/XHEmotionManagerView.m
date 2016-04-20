//
//  XHEmotionManagerView.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionManager.h"
#import "XHEmotionManagerView.h"

#import "XHEmotionSectionBar.h"

#import "XHEmotionCollectionViewCell.h"
#import "XHEmotionCollectionViewFlowLayout.h"


@interface XHEmotionManagerView () <UICollectionViewDelegate, UICollectionViewDataSource, XHEmotionSectionBarDelegate>


/**
 *  显示表情的collectView控件
 */
@property (nonatomic, strong) UIView *lineView;

/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emotionCollectionView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;

/**
 *  管理多种类别gif表情的滚动试图
 */
@property (nonatomic, weak) XHEmotionSectionBar *emotionSectionBar;

/**
 *  当前选择了哪类gif表情标识
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *defaultEmotionItems;

/**
 *  配置默认控件
 */
- (void)setup;

@end

@implementation XHEmotionManagerView

-(void)setup {
    
}

- (void)reloadData {
    NSInteger numberOfEmotionManagers = [self numberOfEmotionManagers];
    if (!numberOfEmotionManagers) {
        return ;
    }

    XHEmotionManager *emotionManager = [self emotionManagerForColumn:self.selectedIndex];
    self.emotionSectionBar.emotionManagers = [self emotionManagersAtManager];
    [self.emotionSectionBar reloadData];

    NSInteger numberOfEmotions = emotionManager.emotions.count;
    int pageNums = [XHEmotionCollectionViewFlowLayout numsOfPerPage:emotionManager.emotionType];
    self.emotionPageControl.numberOfPages = (numberOfEmotions / pageNums + (numberOfEmotions % pageNums ? 1 : 0));
    
    [self.emotionCollectionView reloadData];

    self.emotionCollectionView.collectionViewLayout = [[XHEmotionCollectionViewFlowLayout alloc] init:emotionManager.emotionType];
    [self.emotionCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - Life cycle
- (void)setIsShowEmotionStoreButton:(BOOL)isShowEmotionStoreButton{
    _isShowEmotionStoreButton = isShowEmotionStoreButton;
    if (_emotionSectionBar) {
        _emotionSectionBar.isShowEmotionStoreButton = isShowEmotionStoreButton;
    }
}


- (void)setup:(BOOL)showGif withSend:(BOOL)showSend {
    
    self.isShowEmotionStoreButton = showSend;
    _defaultEmotionItems = [NSMutableArray array];
    
    XHEmotionManager *mgr1 = [[XHEmotionManager alloc] init];
    mgr1.emotionName = @"setion_1";
    mgr1.emotionImg = [UIImage imageNamed:@"emotions.bundle/section_1"];
    mgr1.emotionType = EmotionTypeImg;
    mgr1.emotions = [NSMutableArray array];
    for (int j = 1; j <= 40; j+= 1) {
        NSString *emojiUrl = j < 10? [NSString stringWithFormat:@"titleicon_0%d",j]:[NSString stringWithFormat:@"titleicon_%d",j];
        XHEmotion *e = [[XHEmotion alloc] init];
        e.emotionConverPhoto = [UIImage imageNamed:emojiUrl];
        e.emotionPath = emojiUrl;
        [mgr1.emotions addObject:e];
        if (j % 20 == 0) {
            XHEmotion *e = [[XHEmotion alloc] init];
            e.emotionConverPhoto = [UIImage imageNamed:kXHDelImage];
            e.emotionPath = kXHDelImage;
            [mgr1.emotions addObject:e];
        }
    }
    [_defaultEmotionItems addObject:mgr1];
    
    if (showGif) {
        XHEmotionManager *mgr2 = [[XHEmotionManager alloc] init];
        mgr2.emotionName = @"setion_2";
        mgr2.emotionImg = [UIImage imageNamed:@"emotions.bundle/section_2"];
        mgr2.emotionType = EmotionTypeGif;
        mgr2.emotions = [NSMutableArray array];
        for (int j = 0; j < 16; j+= 1) {
            NSString *emojiUrl = [NSString stringWithFormat:@"emotion%d.gif",j];
            NSString *emotionPath = [NSString stringWithFormat:@"emotions.bundle/section0_emotion%d",j];
            XHEmotion *e = [[XHEmotion alloc] init];
            e.emotionConverPhoto = [UIImage imageNamed:emotionPath];
            e.emotionPath = emojiUrl;
            [mgr2.emotions addObject:e];
        }
        [_defaultEmotionItems addObject:mgr2];
    }

    
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithRed:0xFA/255.0 green:0xFA/255.0 blue:0xFA/255.0 alpha:1.0];
    
    if (!_lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.5, CGRectGetWidth(self.bounds), 0.5)];
        self.lineView.backgroundColor = [UIColor colorWithRed:0xD6/255.0 green:0xD6/255.0 blue:0xD6/255.0 alpha:1.0];
        [self addSubview:_lineView];
    }
    if (!_emotionCollectionView) {
        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kXHEmotionPageControlHeight - kXHEmotionSectionBarHeight) collectionViewLayout:[[XHEmotionCollectionViewFlowLayout alloc] init]];
        emotionCollectionView.backgroundColor = self.backgroundColor;
        [emotionCollectionView registerClass:[XHEmotionCollectionViewCell class] forCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier];
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        [emotionCollectionView setScrollsToTop:NO];
        emotionCollectionView.pagingEnabled = YES;
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;
//        emotionCollectionView collectionViewLayout
        [self addSubview:emotionCollectionView];
        self.emotionCollectionView = emotionCollectionView;
    }
    
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionCollectionView.frame), CGRectGetWidth(self.bounds), kXHEmotionPageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = self.backgroundColor;
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:emotionPageControl];
        self.emotionPageControl = emotionPageControl;
    }
    
    if (!_emotionSectionBar) {
        XHEmotionSectionBar *emotionSectionBar = [[XHEmotionSectionBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPageControl.frame), CGRectGetWidth(self.bounds), kXHEmotionSectionBarHeight) showEmotionStoreButton:self.isShowEmotionStoreButton];
        emotionSectionBar.delegate = self;
        emotionSectionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        emotionSectionBar.backgroundColor = [UIColor clearColor];
        [self addSubview:emotionSectionBar];
        self.emotionSectionBar = emotionSectionBar;
    }
    

    
}

-(void)moveTo:(CGFloat)Y
{
    CGRect frame = self.frame;
    frame.origin.y = Y;
    [UIView animateWithDuration:0.30 animations:^{
        self.frame = frame;
    }];
}

- (void)awakeFromNib {
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.emotionPageControl = nil;
    self.emotionSectionBar = nil;
    self.emotionCollectionView.delegate = nil;
    self.emotionCollectionView.dataSource = nil;
    self.emotionCollectionView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - XHEmotionSectionBar Delegate

- (void)didSelecteEmotionManager:(XHEmotionManager *)emotionManager atSection:(NSInteger)section {
    self.selectedIndex = section;
    self.emotionPageControl.currentPage = 0;

    [self reloadData];
}

- (void)didSend{
    if ([self.delegate respondsToSelector:@selector(didSend)]) {
        [self.delegate didSend];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emotionPageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XHEmotionManager *emotionManager = [self emotionManagerForColumn:self.selectedIndex];
    NSInteger count = emotionManager.emotions.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier forIndexPath:indexPath];
    
    XHEmotionManager *emotionManager = [self emotionManagerForColumn:self.selectedIndex];
    cell.emotion = emotionManager.emotions[indexPath.row];
    cell.emotionType = emotionManager.emotionType;
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XHEmotionManager *emotionManager = [self emotionManagerForColumn:self.selectedIndex];
    XHEmotion *emotion = emotionManager.emotions[indexPath.row];
    
    if ([emotion.emotionPath isEqualToString:kXHDelImage]) {
        if ([self.delegate respondsToSelector:@selector(didClickDelete)]) {
            [self.delegate didClickDelete];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(didSelecteEmotion:emotionType:atIndexPath:)]) {
            [self.delegate didSelecteEmotion:emotion emotionType:emotionManager.emotionType atIndexPath:indexPath];
        }
    }
    
}

#pragma mark - XHEmotionManagerViewDataSource delegate
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column{
    if (self.dataSource) {
        return [self.dataSource emotionManagerForColumn:column];
    }
    return _defaultEmotionItems[column];
}

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
- (NSArray *)emotionManagersAtManager{
    if (self.dataSource) {
        [self.dataSource emotionManagersAtManager];
    }
    return _defaultEmotionItems;
}

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfEmotionManagers{
    if (self.dataSource) {
        [self.dataSource numberOfEmotionManagers];
    }
    return _defaultEmotionItems.count;
}

@end
