//
//  DiscoverController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//
#import "DiscoverController.h"
#import "FriendCircleViewController.h"
#import "PictureViewController.h"
#import "MusicViewController.h"
#import "VideoViewController.h"
#import "MapViewController.h"
#import "WeatherViewController.h"
#import "QrCodeViewController.h"
#import "BankNumberViewController.h"

@implementation DiscoverController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
}

- (void)setupData
{
    //1.分组1
    GroupTableModel *group1 = [[GroupTableModel alloc] init];
    
    TableCellModel *friendModel = [TableCellModel itemWithIcon:@"discover_icon_friendCircle" title:NSLocalizedString(@"Discover_text_friendCircle", @"朋友圈") detailTitle:nil vcClass:[FriendCircleViewController class]];
    
    group1.items = @[friendModel];
    [self.datas addObject:group1];
    
    //2.分组2
    GroupTableModel *group2 = [[GroupTableModel alloc] init];
    
    TableCellModel *pictureModel = [TableCellModel itemWithIcon:@"me_icon_photo" title:NSLocalizedString(@"Discover_text_picture", @"图片") detailTitle:nil vcClass:[PictureViewController class]];
    TableCellModel *musciModel = [TableCellModel itemWithIcon:@"" title:NSLocalizedString(@"Discover_text_music", @"音乐") detailTitle:nil vcClass:[MusicViewController class]];
    TableCellModel *videoModel = [TableCellModel itemWithIcon:@"" title:NSLocalizedString(@"Discover_text_video", @"视频") detailTitle:nil vcClass:[MusicViewController class]];
    
    group2.items = @[pictureModel,musciModel,videoModel];
    [self.datas addObject:group2];
    
    //3.分组3
    GroupTableModel *group3 = [[GroupTableModel alloc] init];
    
    TableCellModel *mapModel = [TableCellModel itemWithIcon:@"tabbar_discover" title:NSLocalizedString(@"Discover_text_map", @"地图") detailTitle:nil vcClass:[MapViewController class]];
    TableCellModel *weatherModel = [TableCellModel itemWithIcon:@"" title:NSLocalizedString(@"Discover_text_weather", @"天气") detailTitle:nil vcClass:[WeatherViewController class]];
    
    group3.items = @[mapModel,weatherModel];
    [self.datas addObject:group3];
    
    //4.分组4
    GroupTableModel *group4 = [[GroupTableModel alloc] init];
    
    TableCellModel *qrCodeModel = [TableCellModel itemWithIcon:@"discover_icon_qrCode" title:NSLocalizedString(@"Discover_text_qrCode", @"二维码") detailTitle:nil vcClass:[QrCodeViewController class]];
    TableCellModel *bankModel = [TableCellModel itemWithIcon:@"" title:NSLocalizedString(@"Discover_text_bankNumber", @"金融指数") detailTitle:nil vcClass:[BankNumberViewController class]];
    
    group4.items = @[qrCodeModel,bankModel];
    [self.datas addObject:group4];
}

@end
