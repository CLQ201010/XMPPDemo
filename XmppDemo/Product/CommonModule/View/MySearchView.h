//
//  HZSearchView.h
//  text
//
//  Created by 范华泽 on 15/11/16.
//  Copyright © 2015年 范华泽. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MySearchViewDelegate <NSObject>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

@end

@interface MySearchView : UIView

/**
 *  搜索框
 */
@property (nonatomic,strong)UISearchBar *searchBar;
/**
 *  searchBar的占位字符
 */
@property (nonatomic,copy)NSString *placeholder;
/**
 *  是否显示取消按钮(默认不显示)
 */
@property (nonatomic)BOOL showsCancelButton;
/**
 *  用来显示结果的tableview
 */
@property (nonatomic,strong)UITableView *searchResultTableView;
/**
 *  searchResultTableView的代理(需要自己在对应的页面中添加,UITableViewDataSource,UITableViewDelegate并实现相关的代理方法)
 */
@property (nonatomic,assign)id <UITableViewDataSource>  searchResultsDataSource;
@property (nonatomic,assign)id <UITableViewDelegate>    searchResultsDelegate;

/**
 *  搜索的代理
 */
@property (nonatomic,assign)id <MySearchViewDelegate> delegate;

@end
