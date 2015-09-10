//
//  LocationViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/6.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"定位";
    [self initUI];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)initUI
{
    [self addMapView];
    [self addTypeButton];
    [self addLocationButton];
    [self addZoomButton];
}


#pragma mark 定位按钮事件
- (void)locationButtonPressed:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning
{
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
