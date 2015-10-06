//
//  UserNoticeViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/10/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "UserNoticeViewController.h"

@interface UserNoticeViewController ()

@end

@implementation UserNoticeViewController

- (void)viewDidLoad
{
    self.title = @"用户服务协议";
    self.urlString = USER_NOTICE_URL;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
