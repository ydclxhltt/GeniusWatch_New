//
//  ChangePasswordViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/16.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "ChangePasswordViewController.h"

#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define SPACE_X             20.0 * CURRENT_SCALE
#define PWD_BTN_WIDTH       80.0
#define PWD_BTN_HEIGHT      30.0
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0

@interface ChangePasswordViewController ()

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
            UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, start_y, PWD_BTN_WIDTH, PWD_BTN_HEIGHT) buttonTitle:@"忘记密码" titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"" tagDelegate:self];
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
        [self.view addSubview:textField];
    }
    
    start_y += TEXTFIELD_HEIGHT + BUTTON_ADD_Y;
}


- (void)addButton
{
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"完成" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"" tagDelegate:self];
    [CommonTool clipView:button withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:button];
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
