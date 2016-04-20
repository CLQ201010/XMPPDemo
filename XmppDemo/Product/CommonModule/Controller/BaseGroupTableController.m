//
//  BaseGroupTableController.m
//  XmppDemo
//
//  Created by clq on 16/1/18.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "BaseGroupTableController.h"
#import "GroupTableModel.h"
#import "TableCellModel.h"
#import "BaseTableCell.h"

@interface BaseGroupTableController ()

@end

@implementation BaseGroupTableController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    
    }
    
    return self;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    
    return _datas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 5, 0);//设置九宫分割
    self.tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
}

#pragma mark 返回几个块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GroupTableModel *groupModel = self.datas[section];
    return groupModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableCell *cell = [BaseTableCell cellWithTableView:tableView identifier:@"BaseTableCell"];
    GroupTableModel *group = self.datas[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableModel *group = self.datas[indexPath.section];
    TableCellModel *item = group.items[indexPath.row];
    if (item.option) {
        item.option();
    }
    else {
        if (item.vcClass != nil) {
            [self.navigationController pushViewController:[[item.vcClass alloc] init] animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 20;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    GroupTableModel *groupModel = self.datas[section];
    return groupModel.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    GroupTableModel *groupModel = self.datas[section];
    return groupModel.footer;
}

@end
