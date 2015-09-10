//
//  GuardSchoolViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SchoolGuardViewController.h"
#import "AddressViewController.h"

@interface SchoolGuardViewController ()<UIActionSheetDelegate>

@end

@implementation SchoolGuardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"校园守护";
    [self addBackItem];
    [self setNavBarItemWithTitle:@"设置" navItemType:RightItem selectorName:@"settingGuardInfo:"];
    // Do any additional setup after loading the view.
}


#pragma mark 设置按钮
- (void)settingGuardInfo:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"守护信息设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"学校信息",@"家-小区信息",nil];
    [actionSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2)
    {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        addressViewController.addressType = (buttonIndex == 0) ? SetAddressTypeSchool : SetAddressTypeHouse;
        [self.navigationController pushViewController:addressViewController animated:YES];
    }
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
