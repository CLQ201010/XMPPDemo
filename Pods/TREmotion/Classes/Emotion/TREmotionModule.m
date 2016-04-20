//
//  TREmotionModule.m
//  TRPet
//
//  Created by wyr on 15/5/1.
//  Copyright (c) 2015年 taro. All rights reserved.
//

//#import <Bridging/Bridging.h>
#import "TREmotionModule.h"
#import "TRKeyboardEmojiViewController.h"

@interface TREmotionModule ()
@property (nonatomic, strong) NSMutableDictionary *tag2urls;
@property (nonatomic, strong) NSMutableArray *formatBlocks;
@end

@implementation TREmotionModule

+ (TREmotionModule *)sharedModule {
    static TREmotionModule *_module = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _module = [TREmotionModule new];
        [_module setup];
    });
    return _module;
}

- (void)setup {
    self.tag2urls = [NSMutableDictionary dictionary];
    
    NSUInteger PageCount = EMOTIONS_PERROW * EMOTIONS_ROWS;

    // test
    NSMutableArray *blocks = [NSMutableArray array];

    
    NSMutableArray *page = nil;
    page = [NSMutableArray array];
    for (int j = 0; j < 45; j+= 1) {
        NSString *emojiUrl = j < 10? [NSString stringWithFormat:@"titleicon_0%d",j]:[NSString stringWithFormat:@"titleicon_%d",j];
        [page addObject:emojiUrl];
    }
    [blocks addObject:page];
    
    page = [NSMutableArray array];
    for (int j = 0; j < 55; j+= 1) {
        NSString *emojiUrl = j < 10? [NSString stringWithFormat:@"titleicon_0%d",j]:[NSString stringWithFormat:@"titleicon_%d",j];
        [page addObject:emojiUrl];
    }
    [blocks addObject:page];
    
    self.formatBlocks = [NSMutableArray array];

    // format emoji resources
    for (NSArray *emojiUrls in blocks) {
        NSMutableArray *formatBlock = [NSMutableArray array];

        NSMutableArray *pageDetail = [NSMutableArray array];
        for (NSString *emojiUrl in emojiUrls) {
            if (pageDetail.count == PageCount - 1) { // 最后一个位置给 X
                pageDetail = [NSMutableArray array];
            }
            if (pageDetail.count == 0) {
                [formatBlock addObject:pageDetail];
            }
            TREmotionVO *vo = [TREmotionVO new];
            vo.emotionUrl = emojiUrl;
            [pageDetail addObject:vo];
        }
        [self.formatBlocks addObject:formatBlock];
    }
    [self setTags];
}

- (NSMutableArray *)emotionBlocks {
    return self.formatBlocks;
}

- (void)setTags {
    int pageCounter = 0;
    for (NSArray *block in self.formatBlocks) {

        NSUInteger blockIndex = [self.formatBlocks indexOfObject:block];

        for (NSArray *page in block) {
            NSUInteger pageIndex = [block indexOfObject:page];

            for (int index = 0; index < page.count; index += 1) {
                TREmotionVO *vo =page[index];

                NSUInteger tag =100000 + blockIndex * 10000 + pageIndex * 1000 + index;
                vo.emotionTag = tag;

                [self.tag2urls setValue:vo.emotionUrl
                                 forKey:[NSString stringWithFormat:@"%d", (int)tag]];
            }
            pageCounter += 1;
        }
    }
}

- (NSString *)urlForTag:(NSUInteger)tag{
    NSString *url = [self.tag2urls objectForKey:[NSString stringWithFormat:@"%d", (int)tag]];
    return url;
}

- (void)updatePageControl:(UIPageControl *)control withPageIndex:(NSUInteger)pageIndex {
    int pageCounter = 0;
    for (int i = 0; i < self.formatBlocks.count; i += 1) {
        NSArray *block = self.formatBlocks[i];
        for (int j = 0; j < block.count; j += 1) {
            if (pageCounter == pageIndex) {
                //  info of pagecontrol
                control.numberOfPages = block.count;
                control.currentPage = j;
            }
            pageCounter += 1;
        }
    }
}

- (NSUInteger)pageIndexOfBlock:(NSUInteger)blockIndex {
    NSUInteger pageCount = 0;
    for (int i = 0; i < self.formatBlocks.count; i += 1) {
        NSArray *block = self.formatBlocks[i];
        if (blockIndex == i) {
            return pageCount;
        }
        pageCount += block.count;
    }
    return pageCount;
}

- (NSUInteger)blockIndexOfPage:(NSUInteger)pageIndex {
    int pageCounter = 0;
    for (int i = 0; i < self.formatBlocks.count; i += 1) {
        NSArray *block = self.formatBlocks[i];

        for (int j = 0; j < block.count; j += 1) {
            if (pageCounter == pageIndex) {
                return i;
            }
            pageCounter += 1;
        }
    }
    return 0;
}

@end
