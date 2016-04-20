//
//  HZSearchView.m
//  text
//
//  Created by 范华泽 on 15/11/16.
//  Copyright © 2015年 范华泽. All rights reserved.
//

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#import "MySearchView.h"

@interface MySearchView ()<UISearchBarDelegate>
/**
 *  取消按钮
 */
@property (nonatomic,strong)UIButton *cancelBtn;
/**
 *  遮罩层
 */
@property (nonatomic,strong)UIButton *maskView;

@end

@implementation MySearchView
{
    CGRect _frame;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, DEF_SCREEN_WIDTH, 44);
        _frame = self.frame;
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:[self searchBar]];
    }
    return self;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        _searchBar.delegate = self;
        [_searchBar setBackgroundColor:[UIColor clearColor]];
        _searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
        [[[_searchBar.subviews objectAtIndex:0].subviews objectAtIndex:0]removeFromSuperview];
        _searchBar.placeholder = self.placeholder;
    }
    return _searchBar;
}
- (UIButton *)cancelBtn{
    if ( !_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(HiddenMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}
- (UIButton *)maskView{
    if (!_maskView) {
        _maskView = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_maskView addTarget:self action:@selector(HiddenMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _maskView;
}
- (UITableView *)searchResultTableView{
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64) style:(UITableViewStylePlain)];
        //        _searchResultTableView.tableFooterView = [[UIView alloc] init];
        //        _searchResultTableView.backgroundColor = [UIColor whiteColor];
        _searchResultTableView.delegate = _searchResultsDelegate;
        _searchResultTableView.dataSource = _searchResultsDataSource;
    }
    return _searchResultTableView;
}
- (void)setShowsCancelButton:(BOOL)showsCancelButton{
    _showsCancelButton = showsCancelButton;
    if (_showsCancelButton == YES) {
        _searchBar.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH-50, 44);
        [self addSubview:[self cancelBtn]];
        _cancelBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-50, 0, 50, 44);
    }else{
        _searchBar.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44);
    }
}
#pragma mark -
- (void)ShowMaskView{
    [self.superview addSubview:[self maskView]];
    _maskView.frame = CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
    [UIView animateWithDuration:.2 animations:^{
        self.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64);
        _searchBar.frame = CGRectMake(0, 20, DEF_SCREEN_WIDTH - 50, 44);
        _cancelBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-50, 20, 50, 44);
        //获取UIView的上层UIViewController
        id object = [self nextResponder];
        while (![object isKindOfClass:[UIViewController class]] &&
               
               object != nil) {
            
            object = [object nextResponder];
            
        }
        UIViewController *VC =(UIViewController*)object;
        VC.navigationController.navigationBarHidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)HiddenMaskView{
    [UIView animateWithDuration:.2 animations:^{
        self.frame = _frame;
        _searchBar.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44);
        [self setShowsCancelButton:self.showsCancelButton];
        
        //获取UIView的上层UIViewController
        id object = [self nextResponder];
        while (![object isKindOfClass:[UIViewController class]] &&
               
               object != nil) {
            
            object = [object nextResponder];
            
        }
        UIViewController *VC =(UIViewController*)object;
        VC.navigationController.navigationBarHidden = NO;
        
    } completion:^(BOOL finished) {
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
        [_maskView removeFromSuperview];
        [_searchResultTableView removeFromSuperview];
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self ShowMaskView];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (_delegate) {
        if (searchBar.text.length != 0) {
            [_maskView addSubview:[self searchResultTableView]];
            [_delegate searchBar:searchBar textDidChange:searchText];
        }
    }
}
@end
