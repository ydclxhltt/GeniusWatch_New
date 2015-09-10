//
//  CheckCodeViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/23.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "CheckCodeViewController.h"
#import "SetPassWordViewController.h"

#define TIP_STRING          @"验证码已发送至手机号:\n"
#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define TIPLABEL_HEIGHT     40.0
#define ADD_Y               40.0
#define SPACE_X             20.0 * CURRENT_SCALE
#define ADD_X               10.0 * CURRENT_SCALE
#define CODE_BUTTON_WIDTH   80.0

#define CODE_TIP            @"获取验证码"
#define CODE_TIP1           @"重新获取"
#define LOADING_TIP         @"正在发送..."
#define LOADING_SUCESS      @"发送成功"
#define LOADING_FAIL        @"发送失败"
#define LOADING_CODE_TIP    @"正在验证..."
#define CODE_SUCESS         @"验证成功"
#define CODE_FAIL           @"验证失败"

@interface CheckCodeViewController ()<UITextFieldDelegate>
{
    NSTimer *countTimer;
    int count;
}

@property (nonatomic, strong) UIButton *getCodeButton;
@property (nonatomic, strong) UITextField *codeTextField;

@end

@implementation CheckCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackItem];
    self.title = @"获取验证码";
    [self addBackItem];
    [self initUI];
    count = 60;
    // Do any additional setup after loading the view.
}

#pragma mark 返回按钮事件
//返回按钮事件
- (void)backButtonPressed:(UIButton *)sender
{
    [self resetTimer];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 初始化UI
- (void)initUI
{
    start_y = SPACE_Y;
    [self addTextField];
    [self addTipLabel];
    [self addButtons];
}

//添加提示文字
- (void)addTipLabel
{
//    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, TIPLABEL_SPAXCE_Y, self.view.frame.size.width, TIPLABEL_HEIGHT) textString:[TIP_STRING stringByAppendingString:self.phoneNumberStr] textColor:[UIColor blackColor] textFont:FONT(16.0)];
//    tipLabel.numberOfLines = 2;
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:tipLabel];
//    
//    start_y = tipLabel.frame.origin.y + tipLabel.frame.size.height + ADD_Y;
}

//添加输入框
- (void)addTextField
{
    
    _codeTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 3 * SPACE_X - CODE_BUTTON_WIDTH, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"您的验证码"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    [CommonTool setViewLayer:_codeTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [CommonTool clipView:_codeTextField withCornerRadius:TEXTFIELD_RADIUS];
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.delegate = self;
    [self.view addSubview:_codeTextField];
    
    start_y += _codeTextField.frame.size.height + ADD_Y;
}

//添加下一步/获取验证码按钮
- (void)addButtons
{
    float start_x = _codeTextField.frame.origin.x + _codeTextField.frame.size.width + ADD_X;
    _getCodeButton = [CreateViewTool createButtonWithFrame:CGRectMake(start_x, _codeTextField.frame.origin.y, self.view.frame.size.width - start_x - SPACE_X, _codeTextField.frame.size.height) buttonTitle:CODE_TIP titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"getCodeButtonPressed:" tagDelegate:self];
    _getCodeButton.titleLabel.font = FONT(12.0);
    [CommonTool clipView:_getCodeButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:_getCodeButton];
    
    
    UIButton *nextButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"下一步" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"nextButtonPressed:" tagDelegate:self];
    [CommonTool clipView:nextButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:nextButton];
}


#pragma mark 获取验证码点击事件
- (void)getCodeButtonPressed:(UIButton *)sender
{
    _getCodeButton.enabled = NO;
    [self createTimer];
    [self getCodeRequest];
}


//创建Timer
- (void)createTimer
{
    if ([countTimer isValid])
    {
        [countTimer invalidate];
    }
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCount:) userInfo:nil repeats:YES];
}

//定时器执行方法
- (void)changeCount:(NSTimer *)timer
{
    count--;
    NSString *titleStr = CODE_TIP;
    if (count == 0)
    {
        [self resetTimer];
    }
    else
    {
        titleStr = [NSString stringWithFormat:@"%@(%ds)",CODE_TIP1,count];
    }
    [_getCodeButton setTitle:titleStr forState:UIControlStateNormal];
}

//清掉定时器
- (void)resetTimer
{
    [countTimer invalidate];
    _getCodeButton.enabled = YES;
    count = 60;
    [_getCodeButton setTitle:CODE_TIP forState:UIControlStateNormal];
}

#pragma mark 获取验证码
- (void)getCodeRequest
{
    [SVProgressHUD showWithStatus:LOADING_TIP];
    __weak typeof(self) weakSelf = self;
    NSString *type = (self.pushType == PushTypeRegister) ? @"reg" : @"chgpwd";
    NSDictionary *requestDic = @{@"mobileNo":self.phoneNumberStr,@"type":type};
    [[RequestTool alloc] requestWithUrl:GET_CODE_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
                         {
                             NSLog(@"GET_CODE===%@",responseDic);
                             NSDictionary *dic = (NSDictionary *)responseDic;
                             //0:成功 417 发送短信验证码失败
                             NSString *errorCode = dic[@"errorCode"];
                             NSString *description = dic[@"description"];
                             description = (description) ? description : LOADING_FAIL;
                             if ([@"0" isEqualToString:errorCode])
                             {
                                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
                             }
                             else
                             {
                                 [weakSelf resetTimer];
                                 [SVProgressHUD showErrorWithStatus:description];
                             }
                         }
                         requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
                         {
                             [weakSelf resetTimer];
                             [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
                         }];
}


#pragma  mark 下一步按钮点击事件
- (void)nextButtonPressed:(UIButton *)sender
{
    NSString *codeStr = self.codeTextField.text;
    codeStr = (codeStr) ? codeStr : @"";
    if (codeStr.length == 0)
    {
        [CommonTool addAlertTipWithMessage:@"请输入正确的验证码"];
    }
    else
    {
        [self.codeTextField resignFirstResponder];
        [self checkCodeRequest];
    }
}

#pragma mark 验证验证码请求
- (void)checkCodeRequest
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_CODE_TIP];
    NSDictionary *requestDic = @{@"mobileNo":self.phoneNumberStr,@"msgValidateCode":self.codeTextField.text};
    [[RequestTool alloc] requestWithUrl:CHECK_CODE_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
                         {
                             NSLog(@"CHECK_CODE===%@",responseDic);
                             NSDictionary *dic = (NSDictionary *)responseDic;
                             //0:成功 401.1 验证码错误
                             NSString *errorCode = dic[@"errorCode"];
                             NSString *description = dic[@"description"];
                             description = (description) ? description : CODE_FAIL;
                             if ([@"0" isEqualToString:errorCode])
                             {
                                 [SVProgressHUD showSuccessWithStatus:CODE_SUCESS];
                                 [weakSelf gotoSetPassword];
                             }
                             else
                             {
                                 [SVProgressHUD showErrorWithStatus:description];
                             }
                         }
                         requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
                         {
                             NSLog(@"CHECK_CODE_error===%@",error);
                             [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
                         }];
}

//跳转到设置密码界面
- (void)gotoSetPassword
{
    SetPassWordViewController *setPasswordViewController = [[SetPassWordViewController alloc] init];
    setPasswordViewController.pushType = self.pushType;
    setPasswordViewController.phoneNumberStr = self.phoneNumberStr;
    [self.navigationController pushViewController:setPasswordViewController animated:YES];
}

#pragma mark UITextFieldDelegate
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
