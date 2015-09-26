//
//  SetPhoneNumberViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/20.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetLinkNumberViewController.h"

#define TIPLABLE_SPACE_Y    NAVBAR_HEIGHT + 10.0 * CURRENT_SCALE
#define TIPLABLE_HEIGHT     25.0
#define SPACE_X             20.0 * CURRENT_SCALE
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0

//更新联系人信息
#define LOADING             @"添加中..."
#define LOADING_SUCESS      @"添加成功"
#define LOADING_FAIL        @"添加失败"

@interface SetLinkNumberViewController ()

@property (nonatomic, strong) NSString *shortNumberStr;
@property (nonatomic, strong) NSString *phoneNumberStr;

@end

@implementation SetLinkNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人号码";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTipLabel];
    [self addTextFields];
    [self addButton];
}

- (void)addTipLabel
{
    UILabel *tipLable = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, TIPLABLE_SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TIPLABLE_HEIGHT) textString:self.linkmanStr textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [self.view addSubview:tipLable];
    
    start_y = tipLable.frame.size.height + tipLable.frame.origin.y + ADD_Y;
}

- (void)addTextFields
{
    UITextField *phoneNumberTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"联系人电话号码"];
    [CommonTool clipView:phoneNumberTextField withCornerRadius:TEXTFIELD_RADIUS];
    [CommonTool setViewLayer:phoneNumberTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    phoneNumberTextField.tag = 100;
    phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNumberTextField];
    
    start_y += phoneNumberTextField.frame.size.height +  ADD_Y;
    UITextField *shortTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"亲情号码/短号"];
    [CommonTool clipView:shortTextField withCornerRadius:TEXTFIELD_RADIUS];
    [CommonTool setViewLayer:shortTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    shortTextField.tag = 101;
    shortTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:shortTextField];
    
    start_y += shortTextField.frame.size.height + BUTTON_ADD_Y;
}


- (void)addButton
{
    UIButton *saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"保存" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"saveButtonPressed:" tagDelegate:self];
    [CommonTool clipView:saveButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:saveButton];
}

#pragma mark 保存
- (void)saveButtonPressed:(UIButton *)sender
{
    if (![self isCanCommit])
    {
        return;
    }
    [self addLinkman];
}

- (BOOL)isCanCommit
{
    NSString *phoneString = ((UITextField *)[self.view viewWithTag:100]).text;
    phoneString = phoneString ? phoneString : @"";
    NSString *shortString = ((UITextField *)[self.view viewWithTag:101]).text;
    shortString = shortString ? shortString : @"";
    NSString *message = @"";
    if (phoneString.length == 0)
    {
        message = @"号码不能为空";
    }
    else if (shortString.length == 0)
    {
        message = @"短号码不能为空";
    }
    else if (![CommonTool isEmailOrPhoneNumber:phoneString])
    {
        message = @"手机号码不正确";
    }
    if (message.length != 0)
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    self.phoneNumberStr = phoneString;
    self.shortNumberStr = shortString;
    return YES;
}

- (void)addLinkman
{
    //__weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING];
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = (imeiNo) ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"binder":[GeniusWatchApplication shareApplication].userName,@"contact":@{@"nickName":self.linkmanStr,@"mobileNo":self.phoneNumberStr,@"shortPhoneNo":self.shortNumberStr,@"userType":@"3"}};
    [[RequestTool alloc] requestWithUrl:ADD_CONTACTS_URL
                            requestParamas:requestDic
                               requestType:RequestTypeAsynchronous
                             requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_LOCATION_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContact" object:nil];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_LOCATION_error====%@",error);
         //[SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
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
