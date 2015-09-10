//
//  AutoAddWatchViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "CustomAddWatchViewController.h"


#define TIP_STRING          @"注:绑定号是16个字母的字符串,请滑动手表屏幕查看!"
#define TEXTFEILD_SPAXCE_Y  NAVBAR_HEIGHT + 15.0
#define TIPLABEL_HEIGHT     40.0
#define ADD_Y               10.0
#define SPACE_X             20.0 * CURRENT_SCALE

#define LOADING             @"正在绑定..."
#define LOADING_SUCESS      @"绑定成功"
#define LOADING_FAIL        @"绑定失败"

@interface CustomAddWatchViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *bindNumberTextField;

@end


@implementation CustomAddWatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"输入绑定号";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTextField];
    [self addTipLabel];
    [self addNextButton];
}



//添加输入框
- (void)addTextField
{
    _bindNumberTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, TEXTFEILD_SPAXCE_Y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(16.0) placeholderText:@"请输入绑定号"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    [CommonTool setViewLayer:_bindNumberTextField withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
    [CommonTool clipView:_bindNumberTextField withCornerRadius:15.0];
    _bindNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _bindNumberTextField.delegate = self;
    [self.view addSubview:_bindNumberTextField];
    
    start_y = _bindNumberTextField.frame.origin.y + _bindNumberTextField.frame.size.height + ADD_Y;
}

//添加提示
- (void)addTipLabel
{
    NSString *tipString = TIP_STRING;
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TIPLABEL_HEIGHT) textString:tipString textColor:[UIColor blackColor] textFont:FONT(15.0)];
    tipLabel.numberOfLines = 2;
    //tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    start_y +=  tipLabel.frame.size.height + ADD_Y;
}



//添加下一步按钮
- (void)addNextButton
{
    UIButton *bindButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"绑定" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:[UIColor grayColor] selectorName:@"bindButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:bindButton withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
    [CommonTool clipView:bindButton withCornerRadius:15.0];
    [self.view addSubview:bindButton];
}

#pragma mark 下一步按钮响应事件
- (void)bindButtonPressed:(UIButton *)sender
{
//    NSString *phoneNumberStr = (_phoneNumberTextField.text) ? _phoneNumberTextField.text : @"";
//    if (![CommonTool isEmailOrPhoneNumber:phoneNumberStr])
//    {
//        [CommonTool addAlertTipWithMessage:@"请输入正确的手机号"];
//    }
//    else
//    {
//        //下一步
//        [self checkPhoneNumber];
//        
//    }
}


//#pragma mark 验证手机号
//- (void)checkPhoneNumber
//{
//    __weak typeof(self) weakSelf = self;
//    [SVProgressHUD showWithStatus:LOADING];
//    NSString *type = (self.pushType == PushTypeRegister) ? @"reg" : @"chgpwd";
//    NSDictionary *requestDic = @{@"mobileNo":_phoneNumberTextField.text,@"type":type};
//    [[RequestTool alloc] requestWithUrl:CHECK_PHONENUMBER_URL
//                         requestParamas:requestDic
//                            requestType:RequestTypeAsynchronous
//                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
//     {
//         NSLog(@"CHECK_PHONENUMBER===%@",responseDic);
//         NSDictionary *dic = (NSDictionary *)responseDic;
//         //0:成功 403.3 手机号码已注册 413.10 未找到手机号
//         NSString *errorCode = dic[@"errorCode"];
//         NSString *description = dic[@"description"];
//         description = (description) ? description : LOADING_FAIL;
//         if ([@"0" isEqualToString:errorCode])
//         {
//             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
//             [weakSelf gotoCheckCode];
//         }
//         else
//         {
//             [SVProgressHUD showErrorWithStatus:description];
//         }
//     }
//                            requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
//     }];
//}
//
//
//#pragma mark 跳转到获取验证码
//- (void)gotoCheckCode
//{
//    CheckCodeViewController *checkViewController = [[CheckCodeViewController alloc] init];
//    checkViewController.pushType = self.pushType;
//    checkViewController.phoneNumberStr = _phoneNumberTextField.text;
//    [self.navigationController pushViewController:checkViewController animated:YES];
//}


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


@end
