//
//  OutSideAddressViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/10/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "OutSideAddressViewController.h"

#define SEARCHBAR_HEIGHT    30.0

@interface OutSideAddressViewController ()<UISearchBarDelegate>

@end

@implementation OutSideAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addSearchBar];
    [self addHeaderView];
    [self addTableView];
}

- (void)addSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入要搜索的地址";
    self.navigationItem.titleView = searchBar;
}

- (void)addHeaderView
{
    
}

- (void)addTableView
{
    
}

#pragma mark UISearchBarDlegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = NO_NULL(searchBar.text);
    if (!text.length)
    {
        //下一页
    }
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
