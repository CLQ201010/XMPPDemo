//
//  EmotionViewController.m
//  EmojiKeyboardDemo
//
//  Created by wyr mini on 15/4/24.
//  Copyright (c) 2015年 wuyr. All rights reserved.
//

#import "TRKeyboardEmojiViewController.h"
#import "TREmotionModule.h"


static float EmojiWidth = 40.0f;
static NSUInteger TagForDeleteButton = 0;

@implementation TREmotionVO
@end


@interface TRKeyboardEmojiViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) TREmotionModule *emotionModule;
@property (weak, nonatomic) IBOutlet UIView *blockView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *blockButtons;

@end

@implementation TRKeyboardEmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self privateInit];
}

//
//- (void)setup:(BOOL)showGif withSend:(BOOL)showSend {
//    
//    self.isShowEmotionStoreButton = showSend;
//    _defaultEmotionItems = [NSMutableArray array];
//    
//    XHEmotionManager *mgr1 = [[XHEmotionManager alloc] init];
//    mgr1.emotionName = @"setion_1";
//    mgr1.emotionImg = [UIImage imageNamed:@"emotions.bundle/section_1"];
//    mgr1.emotionType = EmotionTypeImg;
//    mgr1.emotions = [NSMutableArray array];
//    for (int j = 1; j <= 40; j+= 1) {
//        NSString *emojiUrl = j < 10? [NSString stringWithFormat:@"titleicon_0%d",j]:[NSString stringWithFormat:@"titleicon_%d",j];
//        XHEmotion *e = [[XHEmotion alloc] init];
//        e.emotionConverPhoto = [UIImage imageNamed:emojiUrl];
//        e.emotionPath = emojiUrl;
//        [mgr1.emotions addObject:e];
//        if (j % 20 == 0) {
//            XHEmotion *e = [[XHEmotion alloc] init];
//            e.emotionConverPhoto = [UIImage imageNamed:kXHDelImage];
//            e.emotionPath = kXHDelImage;
//            [mgr1.emotions addObject:e];
//        }
//    }
//    [_defaultEmotionItems addObject:mgr1];
//    
//    if (showGif) {
//        XHEmotionManager *mgr2 = [[XHEmotionManager alloc] init];
//        mgr2.emotionName = @"setion_2";
//        mgr2.emotionImg = [UIImage imageNamed:@"emotions.bundle/section_2"];
//        mgr2.emotionType = EmotionTypeGif;
//        mgr2.emotions = [NSMutableArray array];
//        for (int j = 0; j < 16; j+= 1) {
//            NSString *emojiUrl = [NSString stringWithFormat:@"emotion%d.gif",j];
//            NSString *emotionPath = [NSString stringWithFormat:@"emotions.bundle/section0_emotion%d",j];
//            XHEmotion *e = [[XHEmotion alloc] init];
//            e.emotionConverPhoto = [UIImage imageNamed:emotionPath];
//            e.emotionPath = emojiUrl;
//            [mgr2.emotions addObject:e];
//        }
//        [_defaultEmotionItems addObject:mgr2];
//    }
//    
//    
//    
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//    
//    if (!_emotionCollectionView) {
//        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kXHEmotionPageControlHeight - kXHEmotionSectionBarHeight) collectionViewLayout:[[XHEmotionCollectionViewFlowLayout alloc] init]];
//        emotionCollectionView.backgroundColor = self.backgroundColor;
//        [emotionCollectionView registerClass:[XHEmotionCollectionViewCell class] forCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier];
//        emotionCollectionView.showsHorizontalScrollIndicator = NO;
//        emotionCollectionView.showsVerticalScrollIndicator = NO;
//        [emotionCollectionView setScrollsToTop:NO];
//        emotionCollectionView.pagingEnabled = YES;
//        emotionCollectionView.delegate = self;
//        emotionCollectionView.dataSource = self;
//        //        emotionCollectionView collectionViewLayout
//        [self addSubview:emotionCollectionView];
//        self.emotionCollectionView = emotionCollectionView;
//    }
//    
//    if (!_emotionPageControl) {
//        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionCollectionView.frame), CGRectGetWidth(self.bounds), kXHEmotionPageControlHeight)];
//        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
//        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
//        emotionPageControl.backgroundColor = self.backgroundColor;
//        emotionPageControl.hidesForSinglePage = YES;
//        emotionPageControl.defersCurrentPageDisplay = YES;
//        [self addSubview:emotionPageControl];
//        self.emotionPageControl = emotionPageControl;
//    }
//    
//    if (!_emotionSectionBar) {
//        XHEmotionSectionBar *emotionSectionBar = [[XHEmotionSectionBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPageControl.frame), CGRectGetWidth(self.bounds), kXHEmotionSectionBarHeight) showEmotionStoreButton:self.isShowEmotionStoreButton];
//        emotionSectionBar.delegate = self;
//        emotionSectionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        emotionSectionBar.backgroundColor = [UIColor colorWithWhite:0.886 alpha:1.000];
//        [self addSubview:emotionSectionBar];
//        self.emotionSectionBar = emotionSectionBar;
//    }
//    
//    
//    
//}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:self.scrollView];
}

-(void)privateInit
{
//    handle_tap(self.view, self, nil); // 防止点击被隐藏
//    
//    self.scrollView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
//    
//    self.emotionModule = [TREmotionModule sharedModule];
//    NSMutableArray *blocks = self.emotionModule.emotionBlocks;
//    NSUInteger pageCounter = 0;
//    
//    
//    for (int i = 0; i < blocks.count; i += 1) {
//        NSMutableArray *block = blocks[i];
//        
//        for (int j = 0; j < block.count; j += 1) {
//            
//            NSMutableArray *page = block[j];
//            
//            UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(pageCounter * SCREEN_WIDTH, 0, SCREEN_WIDTH, EmojiWidth * EMOTIONS_ROWS)];
//            [self.scrollView addSubview:pageView];
//            self.scrollView.contentSize = CGSizeMake(pageCounter * SCREEN_WIDTH + SCREEN_WIDTH, 0);
//            
//            // add normal emoji
//            for (int k = 0; k < page.count; k += 1) {
//                UIView *emotionContainer = [self emotionContainer]; // height
//                CGRect emotionContainerRect = emotionContainer.frame;
//                
//                TREmotionVO *vo = page[k];
//                UIButton *emotionView = [self emotionViewWithEmotionVO:vo];
//                
//                int rowIndex = k % EMOTIONS_PERROW;
//                int lineIndex = k / EMOTIONS_PERROW;
//                emotionContainerRect.origin.x = rowIndex * emotionContainerRect.size.width;
//                emotionContainerRect.origin.y = lineIndex * emotionContainerRect.size.height;
//                emotionContainer.frame = emotionContainerRect;
//                
//                [emotionContainer addSubview:emotionView];
//                emotionView.center = CGPointMake(emotionContainerRect.size.width / 2.0, emotionContainerRect.size.height / 2.0);
//                
//                [pageView addSubview:emotionContainer];
//                
//                emotionView.userInteractionEnabled = YES;
//                emotionView.enabled = YES;
//                handle_tap(emotionView, self, @selector(selected:));
//            }
//            // add delete pic
//            [self addDeleteView:pageView];
//            
//            pageCounter += 1;
//        }
//    }
//    
//    [self.scrollView setShowsVerticalScrollIndicator:NO];
//    [self.scrollView setShowsHorizontalScrollIndicator:NO];
//    self.scrollView.pagingEnabled=YES;
//    self.scrollView.delegate=self;
//    
//    
//    // pagecontrol
//    [self scrollViewDidScroll:self.scrollView];
//    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
//    
//    for (UIButton *button in self.blockButtons) {
//        [button addTarget:self action:@selector(onTapBlockButton:) forControlEvents:UIControlEventTouchUpInside];
//    }
}

-(void)addDeleteView:(UIView *)pageView
{
//    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]; // TODO 30
//    deleteImageView.image = [UIImage imageNamed:@"titleicon_18"];
//    
//    UIView *emotionContainer = [self emotionContainer];
//    deleteImageView.center = CGPointMake(emotionContainer.frame.size.width / 2.0, emotionContainer.frame.size.height / 2.0);
//    [emotionContainer addSubview:deleteImageView];
//    CGRect frame =emotionContainer.frame;
//    frame.origin.x = (EMOTIONS_PERROW - 1) * frame.size.width;
//    frame.origin.y = (EMOTIONS_ROWS - 1) * frame.size.height;
//    emotionContainer.frame = frame;
//    emotionContainer.tag = TagForDeleteButton;
//    handle_tap(emotionContainer, self, @selector(selected:));
//    
//    [pageView addSubview:emotionContainer];
}

-(UIView *)emotionContainer
{
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0 * SCREEN_WIDTH / EMOTIONS_PERROW, 40)];
    return nil;
}

-(UIButton *)emotionViewWithEmotionVO:(TREmotionVO *)vo
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, EmojiWidth, EmojiWidth)];
    button.tag = vo.emotionTag;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:vo.emotionUrl]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(0, 0, EmojiWidth, EmojiWidth);
    [button addSubview:imageView];
    return button;
}

-(void)selected:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    if (self.delegate) {
        TREmotionModule *module = [TREmotionModule sharedModule];
        if (view.tag==TagForDeleteButton) {
            [self.delegate emojiViewControllerDidClickDeleteButton];
        }else{
            NSString *str=[module urlForTag:view.tag];
            [self.delegate emojiViewController:self didClickEmotion:str];
        }
    }
}

-(void)pageChange:(UIPageControl *)sender
{
//    NSInteger page = self.pageControl.currentPage;
//    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int page = self.scrollView.contentOffset.x / SCREEN_WIDTH;
//    [self.emotionModule updatePageControl:self.pageControl withPageIndex:page];
//    
//    NSUInteger blockIndex = [self.emotionModule blockIndexOfPage:page];
//    for (int i = 0; i < self.blockButtons.count; i += 1) {
//        UIButton *button = self.blockButtons[i];
//        if (i == blockIndex) {
//            button.titleLabel.textColor = [UIColor blueColor];
//        }else{
//            button.titleLabel.textColor = [UIColor grayColor];
//        }
//    }
}

-(void)onTapBlockButton:(UIButton *)button
{
//    NSUInteger tag = button.tag;
//    NSUInteger pageIndex = [self.emotionModule pageIndexOfBlock:tag];
//    self.scrollView.contentOffset = CGPointMake(pageIndex * SCREEN_WIDTH, 0);
}

//
-(void)setup
{
//    self.view.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, self.view.frame.size.height);
}

-(void)moveTo:(CGFloat)Y
{
    CGRect frame = self.view.frame;
    frame.origin.y = Y;
    [UIView animateWithDuration:0.30 animations:^{
        self.view.frame = frame;
    }];
}

@end
