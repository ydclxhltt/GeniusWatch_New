//
//  ClassTimeViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "ClassTimeViewController.h"

@interface ClassTimeViewController ()

@end

@implementation ClassTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"上课时间";
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addButtons];
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
