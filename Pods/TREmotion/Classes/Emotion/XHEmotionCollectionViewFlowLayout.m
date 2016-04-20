//
//  XHEmotionCollectionViewFlowLayout.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewFlowLayout.h"

@implementation XHEmotionCollectionViewFlowLayout

- (id)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHGifEmotionImageViewSize, kXHGifEmotionImageViewSize);
        int count = [[UIScreen mainScreen] bounds].size.width/(kXHGifEmotionImageViewSize+kXHGifEmotionMinimumLineSpacing);
        CGFloat spacing = [[UIScreen mainScreen] bounds].size.width/count - kXHGifEmotionImageViewSize;
        self.minimumLineSpacing = spacing;
        self.sectionInset = UIEdgeInsetsMake(10, spacing/2, 0, spacing/2);
        self.collectionView.alwaysBounceVertical = YES;
        
    }
    return self;
}

- (id)init:(EmotionType)emotionStyle{
    self = [super init];
    if (self) {
        if (emotionStyle == EmotionTypeGif) {
            self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.itemSize = CGSizeMake(kXHGifEmotionImageViewSize, kXHGifEmotionImageViewSize);
            int count = [XHEmotionCollectionViewFlowLayout numsOfPerLine:EmotionTypeGif];
            CGFloat spacing = [[UIScreen mainScreen] bounds].size.width/count - kXHGifEmotionImageViewSize;
            self.minimumLineSpacing = spacing;
            self.sectionInset = UIEdgeInsetsMake(kXHGifEmotionTopSpacing, spacing/2, 0, spacing/2);
            self.collectionView.alwaysBounceVertical = YES;
        }else{
            self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.itemSize = CGSizeMake(kXHImgEmotionImageViewSize, kXHImgEmotionImageViewSize);
            int count = [XHEmotionCollectionViewFlowLayout numsOfPerLine:EmotionTypeImg];
            CGFloat spacing = [[UIScreen mainScreen] bounds].size.width/count - kXHImgEmotionImageViewSize;
            self.minimumLineSpacing = spacing;
            self.sectionInset = UIEdgeInsetsMake(kXHImgEmotionTopSpacing, spacing/2, 0, spacing/2);
            self.collectionView.alwaysBounceVertical = YES;
        }
       
    }
    return self;
}

+(int)numsOfPerLine:(EmotionType)emotionType{
    if (emotionType == EmotionTypeGif) {
        int count = [[UIScreen mainScreen] bounds].size.width/(kXHGifEmotionImageViewSize+kXHGifEmotionMinimumLineSpacing);
        return count;
    }else{
        int count = [[UIScreen mainScreen] bounds].size.width/(kXHImgEmotionImageViewSize+kXHImgEmotionMinimumLineSpacing);
        return count;
    }
}

+(int)numsOfPerPage:(EmotionType)emotionType{
    if (emotionType == EmotionTypeGif) {
        int count = [[UIScreen mainScreen] bounds].size.width/(kXHGifEmotionImageViewSize+kXHGifEmotionMinimumLineSpacing);
        return count * 2;
    }else{
        int count = [[UIScreen mainScreen] bounds].size.width/(kXHImgEmotionImageViewSize+kXHImgEmotionMinimumLineSpacing);
        return count * 3;
    }
}

@end
