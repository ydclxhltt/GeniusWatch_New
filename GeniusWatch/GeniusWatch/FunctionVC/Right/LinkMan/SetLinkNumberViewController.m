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
    _tipLable = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, TIPLABLE_SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TIPLABLE_HEIGHT) textString:@"联系人" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [self.view addSubview:_tipLable];
    
    start_y = _tipLable.frame.size.height + _tipLable.frame.origin.y + ADD_Y;
}

- (void)addTextFields
{
    UITextField *phoneNumberTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"联系人电话号码"];
    [CommonTool clipView:phoneNumberTextField withCornerRadius:TEXTFIELD_RADIUS];
    [CommonTool setViewLayer:phoneNumberTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    [self.view addSubview:phoneNumberTextField];
    
    start_y += phoneNumberTextField.frame.size.height +  ADD_Y;
    UITextField *shortTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"亲情号码/短号"];
    [CommonTool clipView:shortTextField withCornerRadius:TEXTFIELD_RADIUS];
    [CommonTool setViewLayer:shortTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
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
