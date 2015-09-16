//
//  AfterServiceViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AfterServiceViewController.h"
#import "FeedbackViewController.h"

@interface AfterServiceViewController ()

@end

@implementation AfterServiceViewController

- (void)viewDidLoad
{
    self.title = @"问题与反馈";
    self.urlString = @"http://www.baidu.com";
    [self setNavBarItemWithTitle:@"意见反馈" navItemType:RightItem selectorName:@"feedbackButtonPressed:"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark 意见反馈
- (void)feedbackButtonPressed:(UIButton *)sender
{
    FeedbackViewController * feedbackViewController = [[FeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
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
