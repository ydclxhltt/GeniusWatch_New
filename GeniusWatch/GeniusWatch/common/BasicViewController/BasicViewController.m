//
//  BasicViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/22.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 1.0, self.navigationController.navigationBar.frame.size.width, 1.0) placeholderImage:nil];
    imageView.backgroundColor = APP_MAIN_COLOR;
    [self.navigationController.navigationBar addSubview:imageView];
    
    //[self.navigationController.navigationBar setBackgroundImage:[CommonTool imageWithColor:APP_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[CommonTool imageWithColor:[UIColor redColor]]];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:APP_MAIN_COLOR}];
    //self.navigationController.navigationBar.translucent = YES;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}


#pragma mark 设置导航条Item

// 1.设置导航条Item
- (void)setNavBarItemWithTitle:(NSString *)title navItemType:(NavItemType)type selectorName:(NSString *)selName
{
    //UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                                                               target:nil action:nil];
    //negativeSpacer.width = (LeftItem == type) ? -15 : 15;
    //float x = negativeSpacer.width;
    //float x = (LeftItem == type) ? negativeSpacer.width : 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(x, 0, 60, 30);
    button.frame = CGRectMake(0, 0, 60, 30);
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = FONT(17.0);
    [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    if (selName && ![@"" isEqualToString:selName])
    {
        [button addTarget:self action:NSSelectorFromString(selName) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem  *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if(LeftItem == type)
        //self.navigationItem.leftBarButtonItems = @[negativeSpacer,barItem];
        self.navigationItem.leftBarButtonItems = @[barItem];
    else if (RightItem == type)
        self.navigationItem.rightBarButtonItems = @[barItem];
}


// 2.设置导航条Item
- (void)setNavBarItemWithImageName:(NSString *)imageName navItemType:(NavItemType)type selectorName:(NSString *)selName
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = (LeftItem == type) ? -15 : 15;
    //float x = (LeftItem == type) ? negativeSpacer.width : 0;
    //float x = negativeSpacer.width;
    
    UIImage *image_up = [UIImage imageNamed:[imageName stringByAppendingString:@"_up"]];
    UIImage *image_down = [UIImage imageNamed:[imageName stringByAppendingString:@"_down"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(x, 0, image_up.size.width/2, image_up.size.height/2);
    button.frame = CGRectMake(0, 0, image_up.size.width/2, image_up.size.height/2);
    [button setBackgroundImage:image_up forState:UIControlStateNormal];
    [button setBackgroundImage:image_down forState:UIControlStateHighlighted];
    [button setBackgroundImage:image_down forState:UIControlStateSelected];
    if (selName && ![@"" isEqualToString:selName])
    {
        [button addTarget:self action:NSSelectorFromString(selName) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem  *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if(LeftItem == type)
        //self.navigationItem.leftBarButtonItems = @[negativeSpacer,barItem];
        self.navigationItem.leftBarButtonItems = @[barItem];
    else if (RightItem == type)
        self.navigationItem.rightBarButtonItems = @[barItem];
}

#pragma mark 添加返回Item
//添加返回按钮
- (void)addBackItem
{
    [self setNavBarItemWithImageName:@"back" navItemType:LeftItem selectorName:@"backButtonPressed:"];
}

- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加表
//添加表
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate
{
    _table=[[UITableView alloc]initWithFrame:frame style:type];
    _table.dataSource=delegate;
    _table.delegate=delegate;
    [self.view addSubview:_table];
    [self setExtraCellLineHidden:_table];
}


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
