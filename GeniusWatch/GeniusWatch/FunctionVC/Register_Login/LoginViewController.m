//
//  LoginViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/23.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainSideViewController.h"
#import "AddWatchTipViewController.h"

#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0
#define SPACE_X             20.0 * CURRENT_SCALE
#define PWD_BTN_WIDTH       80.0
#define REGISTE_BTN_SPACE   15.0

#define LOADING_FAIL        @"登录失败"
#define LOADING_SUCESS      @"登录成功"
#define LOADING_TIP         @"正在登录..."

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    if (self.isShowBackItem)
    {
        [self addBackItem];
        
    }
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTextFields];
    [self addButtons];
}

//添加输入框
- (void)addTextFields
{
    start_y += SPACE_Y;
    
    _usernameTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"用户名"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    _usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [CommonTool setViewLayer:_usernameTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [CommonTool clipView:_usernameTextField withCornerRadius:TEXTFIELD_RADIUS];
    _usernameTextField.delegate = self;
    _usernameTextField.text = @"15220230746";
    [self.view addSubview:_usernameTextField];
    
    start_y += _usernameTextField.frame.size.height + ADD_Y;
    
    _passwordTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"密码"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    [CommonTool setViewLayer:_passwordTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [CommonTool clipView:_passwordTextField withCornerRadius:TEXTFIELD_RADIUS];
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.text = @"123456";
    [self.view addSubview:_passwordTextField];
    
    start_y += _passwordTextField.frame.size.height;
}

//添加登陆按钮/忘记密码按钮
- (void)addButtons
{
    UIButton *getPasswordButton = [CreateViewTool createButtonWithFrame:CGRectMake(_passwordTextField.frame.size.width + _passwordTextField.frame.origin.x - PWD_BTN_WIDTH, start_y, PWD_BTN_WIDTH, BUTTON_HEIGHT) buttonTitle:@"忘记密码" titleColor:APP_MAIN_COLOR normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:nil selectorName:@"getPasswordButtonPressed:" tagDelegate:self];
    getPasswordButton.titleLabel.font = BUTTON_FONT;
    getPasswordButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:getPasswordButton];
    
    start_y += getPasswordButton.frame.size.height + BUTTON_ADD_Y;
    
    UIButton *loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"登录" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"loginButtonPressed:" tagDelegate:self];
    loginButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:loginButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:loginButton];
    
    
    start_y = self.view.frame.size.height - BUTTON_HEIGHT - REGISTE_BTN_SPACE;
    
    UIButton *registerButton = [CreateViewTool createButtonWithFrame:CGRectMake((self.view.frame.size.width - PWD_BTN_WIDTH)/2, start_y, PWD_BTN_WIDTH, BUTTON_HEIGHT) buttonTitle:@"注册" titleColor:APP_MAIN_COLOR normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:nil selectorName:@"registerButtonPrssed:" tagDelegate:self];
    registerButton.titleLabel.font = FONT(17.0);
    registerButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:registerButton];
}


#pragma mark 点击登录按钮
- (void)loginButtonPressed:(UIButton *)sender
{
    [_passwordTextField resignFirstResponder];
    [_usernameTextField resignFirstResponder];
    
    if ([self isCanCommit])
    {
        //登录请求
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSucess" object:nil];
        //[self loginRequest];
    }
}

//验证数据是否合法
- (BOOL)isCanCommit
{
    NSString *username = _usernameTextField.text;
    username = (username) ? username : @"";
    NSString *password = _passwordTextField.text;
    password = (password) ? password : @"";
    
    NSString *meaasge = @"";
    
    if (![CommonTool isEmailOrPhoneNumber:username])
    {
        meaasge = @"请输入正确的手机号";
    }
    else if (password.length < 6)
    {
        meaasge = @"密码不能少于6位";
    }
    
    if (meaasge.length == 0)
    {
        return YES;
    }
    else
    {
        [CommonTool addAlertTipWithMessage:meaasge];
        return NO;
    }
}

#pragma mark 登录请求
- (void)loginRequest
{
    [SVProgressHUD showWithStatus:LOADING_TIP];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"logonAccount":_usernameTextField.text,@"logonPassword":_passwordTextField.text};
    [[RequestTool alloc] requestWithUrl:LOGIN_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
                         {
                             NSLog(@"LOGIN===%@",responseDic);
                             NSDictionary *dic = (NSDictionary *)responseDic;
                             //0:成功 401.1 账号或密码错误 404 账号不存在
                             NSString *errorCode = dic[@"errorCode"];
                             NSString *description = dic[@"description"];
                             description = (description) ? description : LOADING_FAIL;
                             if ([@"0" isEqualToString:errorCode])
                             {
                                 NSArray *devicesArray = ([dic[@"bind"][@"devices"] isKindOfClass:[NSNull class]]) ? nil : dic[@"bind"][@"devices"];
                                 NSString *phoneString = dic[@"bind"][@"binder"];
                                 phoneString = (phoneString) ? phoneString : @"";
                                 [GeniusWatchApplication shareApplication].userName = phoneString;
                                 if (!devicesArray || [devicesArray count] == 0)
                                 {
                                    [weakSelf addWatchView];
                                 }
                                 else
                                 {
                                     [weakSelf addMainViewWithData:devicesArray];
                                     
                                 }
                                [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
                             }
                             else
                             {
                                 [SVProgressHUD showErrorWithStatus:description];
                             }
                         }
                         requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
                         {
                             NSLog(@"LOGINerror====%@",error);
                             [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
                         }];
}


//进入主界面
- (void)addMainViewWithData:(NSArray *)deviceArray
{
    if ([GeniusWatchApplication shareApplication].isLaunchLogin)
    {
        [GeniusWatchApplication shareApplication].deviceList = [NSMutableArray arrayWithArray:deviceArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSucess" object:nil];
    }
    else
    {
        [GeniusWatchApplication shareApplication].isLaunchLogin = YES;
        [[MainSideViewController sharedSliderController] hideSideViewController:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

//添加手表
- (void)addWatchView
{
    AddWatchTipViewController *addWatchTipViewController = [[AddWatchTipViewController alloc] init];
    [self.navigationController pushViewController:addWatchTipViewController animated:YES];
}


#pragma mark  点击忘记密码按钮
- (void)getPasswordButtonPressed:(UIButton *)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.pushType = PushTypeNewPassword;
    [self.navigationController pushViewController:registerViewController animated:YES];
}


#pragma mark  点击注册按钮
- (void)registerButtonPrssed:(UIButton *)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.pushType = PushTypeRegister;
    [self.navigationController pushViewController:registerViewController animated:YES];
}


#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
