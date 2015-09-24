//
//  ChangePasswordViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/16.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CheckCodeViewController.h"

#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define SPACE_X             20.0 * CURRENT_SCALE
#define PWD_BTN_WIDTH       80.0
#define PWD_BTN_HEIGHT      30.0
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0

//更新密码
#define LOADING             @"更新密码..."
#define LOADING_SUCESS      @"更新成功"
#define LOADING_FAIL        @"更新失败"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) NSString *oldPwdString;
@property (nonatomic, strong) NSString *setPwdString;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTextFields];
    [self addButton];
}

- (void)addTextFields
{
    NSArray *array = @[@"原始密码",@"新密码",@"确认密码"];
    float width = self.view.frame.size.width - 2 * SPACE_X;
    start_y = 0.0;
    for (int i = 0; i < 3; i++)
    {
        start_y = SPACE_Y + TEXTFIELD_HEIGHT * i + ADD_Y * i;
        if (i == 1)
        {
            start_y -= ADD_Y;
            float x = self.view.frame.size.width - SPACE_X - PWD_BTN_WIDTH;
            UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, start_y, PWD_BTN_WIDTH, PWD_BTN_HEIGHT) buttonTitle:@"忘记密码" titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"forgetPasswordButtonPressed:" tagDelegate:self];
            button.titleLabel.font = FONT(16.0);
            [self.view addSubview:button];
        }
        if (i > 0)
        {
            start_y += PWD_BTN_HEIGHT + ADD_Y;
        }
        UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, width, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:array[i]];
        [CommonTool setViewLayer:textField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
        [CommonTool clipView:textField withCornerRadius:TEXTFIELD_RADIUS];
        textField.secureTextEntry = YES;
        textField.text = @"";
        textField.tag = i + 100;
        [self.view addSubview:textField];
    }
    
    start_y += TEXTFIELD_HEIGHT + BUTTON_ADD_Y;
}


- (void)addButton
{
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"完成" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"commitButtonPressed:" tagDelegate:self];
    [CommonTool clipView:button withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:button];
}


#pragma mark 忘记密码
- (void)forgetPasswordButtonPressed:(UIButton *)sender
{
    CheckCodeViewController *checkViewController = [[CheckCodeViewController alloc] init];
    checkViewController.pushType = PushTypeChagePassword;
    checkViewController.phoneNumberStr = [GeniusWatchApplication shareApplication].userName;
    [self.navigationController pushViewController:checkViewController animated:YES];
}

#pragma mark 修改密码
- (void)commitButtonPressed:(UIButton *)sender
{
    if (![self isCanCommit])
    {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSLog(@"====%@",CHG_PWD_URL);
    NSDictionary *requestDic = @{@"logonAccount":[GeniusWatchApplication shareApplication].userName,@"oldPwd":self.oldPwdString,@"newPwd":self.setPwdString};
    NSLog(@"====%@",requestDic);
    [[RequestTool alloc] requestWithUrl:CHG_PWD_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"CHG_PWD_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"CHG_PWD_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
}
- (BOOL)isCanCommit
{
    NSString *oldPassword = ((UITextField *)[self.view viewWithTag:100]).text;
    NSString *newPassword = ((UITextField *)[self.view viewWithTag:101]).text;
    NSString *surePassword = ((UITextField *)[self.view viewWithTag:102]).text;
    NSString *message = @"";
    if (oldPassword.length == 0 || newPassword.length == 0 || surePassword.length == 0 )
    {
        message = @"密码不能为空";
    }
    else if (oldPassword.length < 6 || newPassword.length < 6 || surePassword.length < 6 )
    {
        message = @"密码不能小于六位";
    }
    else if (![newPassword isEqualToString:surePassword])
    {
        message = @"密码不一致";
    }
    if (message.length != 0)
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    self.oldPwdString = oldPassword;
    self.setPwdString = newPassword;
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
