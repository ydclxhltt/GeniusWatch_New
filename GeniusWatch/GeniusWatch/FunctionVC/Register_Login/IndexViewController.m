//
//  IndexViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/22.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "IndexViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

#define BUTTON_SPACE_X 60.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y 75.0 * CURRENT_SCALE
#define BUTTON_ADD_Y   25.0 * CURRENT_SCALE

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)initUI
{
    [self addBgImageView];
    [self addButtons];
}

- (void)addBgImageView
{
    UIImage *bgImage = [UIImage imageNamed:(SCREEN_HEIGHT == 480.0) ? @"register_bg" : @"register_bg1"];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) placeholderImage:bgImage];
    [self.view addSubview:imageView];
}

- (void)addButtons
{
    float buttonWidth = self.view.frame.size.width - 2 * BUTTON_SPACE_X;
    float buttonY = self.view.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y;
    
    UIButton *registerButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, buttonY, buttonWidth, BUTTON_HEIGHT) buttonTitle:@"注册" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"registerButtonPressed:" tagDelegate:self];
    registerButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:registerButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:registerButton];
    
    buttonY += - registerButton.frame.size.height - BUTTON_ADD_Y;
    
    UIButton *loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, buttonY, buttonWidth, BUTTON_HEIGHT) buttonTitle:@"登录" titleColor:[UIColor whiteColor] normalBackgroundColor:RGB(157.0, 0.0, 12.0) highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"loginButtonPressed:" tagDelegate:self];
    loginButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:loginButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:loginButton];
}


- (void)registerButtonPressed:(UIButton *)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.pushType = PushTypeRegister;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)loginButtonPressed:(UIButton *)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.isShowBackItem = YES;
    [self.navigationController pushViewController:loginViewController animated:YES];
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
