//
//  UserSettingController.m
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "UserSettingController.h"
#import "SettingViewCell.h"
#import "SettingModel.h"
#import "LoginController.h"
#import "MyNavController.h"

@interface UserSettingController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation UserSettingController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    
    return self;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Me_text_setting", comment:@"设置");
    [self setupData];
}

- (void)setupData
{
    //1.添加第一组
    SettingModel *accoutModel = [SettingModel settingWithTile: NSLocalizedString(@"Me_text_security", comment:@"账号与安全") detailTitle:@"" vcClass:nil option:nil];
    [self.dataArray addObject:@[accoutModel]];
    //2.添加第二组
    SettingModel *newMessageModel = [SettingModel settingWithTile:NSLocalizedString(@"Me_text_newMessage", comment:@"新消息通知") detailTitle:@"" vcClass:nil option:nil];
    SettingModel *privacyModel = [SettingModel settingWithTile:NSLocalizedString(@"Me_text_privacy", comment:@"隐私") detailTitle:@"" vcClass:nil option:nil];
    
    SettingModel *curremcyModel = [SettingModel settingWithTile:NSLocalizedString(@"Me_text_curremcy", comment:@"通用") detailTitle:@"" vcClass:nil option:nil];
    [self.dataArray addObject:@[newMessageModel,privacyModel,curremcyModel]];
    //3.添加第三组
    SettingModel *feedbackModel = [SettingModel settingWithTile:NSLocalizedString(@"Me_text_feedback", comment:@"帮助与反馈") detailTitle:@"" vcClass:nil option:nil];
    SettingModel *aboutModel = [SettingModel settingWithTile:NSLocalizedString(@"Me_text_about", comment:@"关于微信") detailTitle:@"" vcClass:nil option:nil];
    [self.dataArray addObject:@[feedbackModel,aboutModel]];
    //4.添加第四组
    SettingModel *signOutModel = [SettingModel settingWithTile:NSLocalizedString(@"Me_text_signout", comment:@"退出登录") detailTitle:@"" vcClass:nil option:^{
        [self SignOut];
    }];
    signOutModel.isLoginOut = YES;
    [self.dataArray addObject:@[signOutModel]];
}

- (void)SignOut
{
    //退出
    XmppTools *xmpp = [XmppTools sharedxmpp];
    [xmpp xmppLoginOut];
    [FmbdMessage close];
    [FmdbTool close];
    //跳转到登陆界面
    [self dismissViewControllerAnimated:NO completion:nil];
 
    LoginController *loginController = [[LoginController alloc] init];
    MyNavController *nav = [[MyNavController alloc] initWithRootViewController:loginController];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView identifier:@"settingviewcell"];
    
    NSArray *array = self.dataArray[indexPath.section];
    cell.settingModel = array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];
    SettingModel *settingModel = array[indexPath.row];
    if (settingModel.option != nil) {
        settingModel.option();
    }
    else {
        if (settingModel.vcClass != nil) {
            [self.navigationController pushViewController:[[settingModel.vcClass alloc] init] animated:YES];
        }
    }
}

@end
