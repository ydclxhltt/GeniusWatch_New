//
//  RegisterViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/23.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "RegisterViewController.h"
#import "CheckCodeViewController.h"

#define TIP_STRING          @"请先输入您的手机号码\n(注:请用家长手机号码注册账号)"
#define TIP_STRING1         @"请先输入您的手机号"
#define TIPLABEL_SPAXCE_Y   NAVBAR_HEIGHT + 30.0
#define TIPLABEL_HEIGHT     40.0

#define ADD_Y               40.0
#define SPACE_X             20.0 * CURRENT_SCALE

#define LOADING             @"正在验证..."
#define LOADING_SUCESS      @"验证成功"
#define LOADING_FAIL        @"验证失败"


@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneNumberTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手机号码";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    start_y = TIPLABEL_SPAXCE_Y;
    //[self addTipLabel];
    [self addTextField];
    [self addNextButton];
}

//添加提示
//- (void)addTipLabel
//{
//    NSString *tipString = (self.pushType == PushTypeRegister)? TIP_STRING : TIP_STRING1;
//    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, TIPLABEL_SPAXCE_Y, self.view.frame.size.width, TIPLABEL_HEIGHT) textString:tipString textColor:[UIColor blackColor] textFont:FONT(15.0)];
//    tipLabel.numberOfLines = (self.pushType == PushTypeRegister) ? 2 : 1;
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:tipLabel];
//    
//    start_y = tipLabel.frame.origin.y + tipLabel.frame.size.height + ADD_Y;
//}

//添加输入框
- (void)addTextField
{
    _phoneNumberTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"您的手机号码"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    [CommonTool setViewLayer:_phoneNumberTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [CommonTool clipView:_phoneNumberTextField withCornerRadius:TEXTFIELD_RADIUS];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTextField.delegate = self;
    [self.view addSubview:_phoneNumberTextField];
    start_y += _phoneNumberTextField.frame.size.height + ADD_Y;
}

//添加下一步按钮
- (void)addNextButton
{

    UIButton *nextButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"下一步" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"nextButtonPressed:" tagDelegate:self];
    nextButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:nextButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:nextButton];
}

#pragma mark 下一步按钮响应事件
- (void)nextButtonPressed:(UIButton *)sender
{
    NSString *phoneNumberStr = (_phoneNumberTextField.text) ? _phoneNumberTextField.text : @"";
    if (![CommonTool isEmailOrPhoneNumber:phoneNumberStr])
    {
        [CommonTool addAlertTipWithMessage:@"请输入正确的手机号"];
    }
    else
    {
        //下一步
        [_phoneNumberTextField resignFirstResponder];
        [self checkPhoneNumber];
    }
}


#pragma mark 验证手机号
- (void)checkPhoneNumber
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING];
    NSString *type = (self.pushType == PushTypeRegister) ? @"reg" : @"chgpwd";
    NSDictionary *requestDic = @{@"mobileNo":_phoneNumberTextField.text,@"type":type};
    [[RequestTool alloc] requestWithUrl:CHECK_PHONENUMBER_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
                          {
                              NSLog(@"CHECK_PHONENUMBER===%@",responseDic);
                              NSDictionary *dic = (NSDictionary *)responseDic;
                              //0:成功 403.3 手机号码已注册 413.10 未找到手机号
                              NSString *errorCode = dic[@"errorCode"];
                              NSString *description = dic[@"description"];
                              description = (description) ? description : LOADING_FAIL;
                              if ([@"0" isEqualToString:errorCode])
                              {
                                  [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
                                  [weakSelf gotoGetCode];
                              }
                              else
                              {
                                  [SVProgressHUD showErrorWithStatus:description];
                              }
                          }
                          requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
                          {
                               NSLog(@"CHECK_PHONENUMBER——error===%@",error);
                              [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
                          }];
}


#pragma mark 跳转到获取验证码
- (void)gotoGetCode
{
    CheckCodeViewController *checkViewController = [[CheckCodeViewController alloc] init];
    checkViewController.pushType = self.pushType;
    checkViewController.phoneNumberStr = _phoneNumberTextField.text;
    [self.navigationController pushViewController:checkViewController animated:YES];
}


#pragma UITextFieldDelegate
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
