//
//  ApplyInformationViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/13.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "ApplyInformationViewController.h"
#import "BindApplyStatusViewController.h"

#define TIP_STRING          @"绑定该手表,需要获得手表管理员的同意\n(请确保管理员的APP是开启状态)"
#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define TIPLABEL_HEIGHT     40.0
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0
#define SPACE_X             20.0 * CURRENT_SCALE

@interface ApplyInformationViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *applyInformationTextField;

@end

@implementation ApplyInformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    self.title = @"申请信息";
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
    _applyInformationTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(16.0) placeholderText:@"请输入申请认证信息"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    [CommonTool setViewLayer:_applyInformationTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [CommonTool clipView:_applyInformationTextField withCornerRadius:TEXTFIELD_RADIUS];
    _applyInformationTextField.delegate = self;
    [self.view addSubview:_applyInformationTextField];
    
    start_y = _applyInformationTextField.frame.origin.y + _applyInformationTextField.frame.size.height + ADD_Y;
}

//添加提示
- (void)addTipLabel
{
    NSString *tipString = TIP_STRING;
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TIPLABEL_HEIGHT) textString:tipString textColor:TIP_COLOR textFont:FONT(15.0)];
    tipLabel.numberOfLines = 2;
    //tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    start_y +=  tipLabel.frame.size.height + BUTTON_ADD_Y;
}



//添加下一步按钮
- (void)addNextButton
{
    UIButton *sendButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"发送申请" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"sendButtonPressed:" tagDelegate:self];
    [CommonTool clipView:sendButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:sendButton];
}

#pragma mark 发送
- (void)sendButtonPressed:(UIButton *)sender
{
    BindApplyStatusViewController *bindApplyStatusViewController = [[BindApplyStatusViewController alloc] init];
    [self.navigationController pushViewController:bindApplyStatusViewController animated:YES];
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
