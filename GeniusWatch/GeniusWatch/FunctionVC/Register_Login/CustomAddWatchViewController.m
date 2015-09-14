//
//  AutoAddWatchViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "CustomAddWatchViewController.h"
#import "ApplyInformationViewController.h"


#define TIP_STRING          @"注:绑定号是16个字母的字符串,请滑动手表屏幕查看!"
#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define TIPLABEL_HEIGHT     40.0
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0
#define SPACE_X             20.0 * CURRENT_SCALE


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
    _bindNumberTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"请输入绑定号"];
    //_phoneNumberTextField.borderStyle = UITextBorderStyleLine;
    [CommonTool setViewLayer:_bindNumberTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [CommonTool clipView:_bindNumberTextField withCornerRadius:TEXTFIELD_RADIUS];
    _bindNumberTextField.delegate = self;
    [self.view addSubview:_bindNumberTextField];
    
    start_y = _bindNumberTextField.frame.origin.y + _bindNumberTextField.frame.size.height + ADD_Y;
}

//添加提示
- (void)addTipLabel
{
    NSString *tipString = TIP_STRING;
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TIPLABEL_HEIGHT) textString:tipString textColor:TIP_COLOR textFont:TIP_FONT];
    tipLabel.numberOfLines = 2;
    //tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    start_y +=  tipLabel.frame.size.height + BUTTON_ADD_Y;
}



//添加下一步按钮
- (void)addNextButton
{
    UIButton *bindButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"绑定" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"bindButtonPressed:" tagDelegate:self];
    [CommonTool clipView:bindButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:bindButton];
}

#pragma mark 下一步按钮响应事件
- (void)bindButtonPressed:(UIButton *)sender
{
    NSString *watchID = _bindNumberTextField.text;
    watchID = (watchID) ? watchID : @"";
    if (watchID.length != 16)
    {
        [CommonTool addAlertTipWithMessage:@"请输入正确的手表绑定号"];
    }
    else
    {
        ApplyInformationViewController *applyInformationViewController = [[ApplyInformationViewController alloc] init];
        applyInformationViewController.watchID = watchID;
        [self.navigationController pushViewController:applyInformationViewController animated:YES];
    }
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


@end
