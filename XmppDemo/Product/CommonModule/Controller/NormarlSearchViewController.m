//
//  NormarlSearchViewController.m
//  XmppDemo
//
//  Created by clq on 16/5/27.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "NormarlSearchViewController.h"
#import "UserSearchModel.h"
#import "NormalSearchTableViewCell.h"

@interface NormarlSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *placeholderStr;
@property (nonatomic,strong) UITableView *resultTableView;
@property (nonatomic,strong) UITextField *searchFiled;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSArray *resultDatas;

@end

@implementation NormarlSearchViewController

- (instancetype)initWithPlaceHolder:(NSString *)text
{
    self = [super init];
    if (self)
    {
        self.placeholderStr = text;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addNotification];
}
- (void)dealloc
{
    [self removeNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSearchResult:) name:RESULT_USERNAME_SEARCH object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.searchFiled becomeFirstResponder];
}

- (void)setupUI
{
    //1.背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //2.设置头部
    [self setupHeadView];
    //3.设置搜索结果
    [self setupResultTableView];
}

- (void)setupHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth,64)];
    headView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headView];
    
    //1.设置搜索框
    CGFloat serachX = 5;
    CGFloat searchY = 25;
    CGFloat searchW = ScreenWidth - 60.0;
    CGFloat searchH = 34;
    self.searchFiled = [[UITextField alloc] initWithFrame:CGRectMake(serachX,searchY,searchW,searchH)];
    self.searchFiled.backgroundColor = [UIColor whiteColor];
    self.searchFiled.placeholder = self.placeholderStr;
    self.searchFiled.font = [UIFont systemFontOfSize:14.0];
    self.searchFiled.textColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0];
    self.searchFiled.delegate = self;
    self.searchFiled.returnKeyType = UIReturnKeySearch;
    self.searchFiled.borderStyle = UITextBorderStyleRoundedRect;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    leftView.image = [UIImage imageNamed:@"contacter_icon_search"];
    self.searchFiled.leftView = leftView;
    self.searchFiled.leftViewMode = UITextFieldViewModeAlways;
    [headView addSubview:self.searchFiled];
    
    //2.设置取消按钮
    CGFloat cancelBtnW = 44;
    CGFloat cancelBtnX = ScreenWidth- cancelBtnW - 5;
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtnX, searchY, cancelBtnW, searchH)];
    [self.cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:NSLocalizedString(@"Common_text_cancel", @"取消") forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.cancelBtn];
}

- (void)setupResultTableView
{
    self.resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
    [self.view addSubview:self.resultTableView];
}

-(void)showMessage:(NSString *)msg
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Contacter_text_reminder", comment:@"温馨提示") message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Contacter_text_OK", comment:@"好的") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Notification Handle

- (void)handleSearchResult:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
       self.resultDatas = [notification object];
       [self.resultTableView reloadData];
    });
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[XmppTools sharedxmpp] searchByUserName:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultDatas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalSearchTableViewCell *cell = [NormalSearchTableViewCell cellWithTableView:tableView identifier:@"normarlSearchCell"];
    UserSearchModel *user = self.resultDatas[indexPath.row];
    cell.userSearchModel = user;

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
