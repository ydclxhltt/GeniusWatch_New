//
//  AddWatchTipViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/12.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddWatchTipViewController.h"
#import "AddWatchViewController.h"

#define ADD_WATCH_TIP           @"您需要绑定手表才能正常使用功能!"
#define SPACE_Y                 NAVBAR_HEIGHT + 30.0
#define BUTTON_ADD_Y            40.0
#define SPACE_X                 20.0 * CURRENT_SCALE
#define CHAGE_ACCOUNT_WIDTH     80.0

@interface AddWatchTipViewController()

@end

@implementation AddWatchTipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定手表";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTipView];
    [self addButtons];
}

- (void)addTipView
{
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textString:ADD_WATCH_TIP textColor:TIP_COLOR textFont:TIP_FONT];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    start_y = tipLabel.frame.size.height + tipLabel.frame.origin.y + BUTTON_ADD_Y;
}


- (void)addButtons
{
    UIButton *sureButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"立即绑定手表" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"addWatchButtonPressed:" tagDelegate:self];
    [CommonTool clipView:sureButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:sureButton];
    
    start_y += sureButton.frame.size.height;
    UIButton *changeAccountButton = [CreateViewTool createButtonWithFrame:CGRectMake(sureButton.frame.size.width + sureButton.frame.origin.x - CHAGE_ACCOUNT_WIDTH, start_y, CHAGE_ACCOUNT_WIDTH, BUTTON_HEIGHT) buttonTitle:@"切换账户" titleColor:APP_MAIN_COLOR normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:nil selectorName:@"changeAccountButtonPressed:" tagDelegate:self];
    changeAccountButton.titleLabel.font = BUTTON_FONT;
    changeAccountButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:changeAccountButton];
}


#pragma mark 添加手表
- (void)addWatchButtonPressed:(UIButton *)sender
{
    AddWatchViewController *addWatchViewController = [[AddWatchViewController alloc] init];
    addWatchViewController.showType = ShowTypePush;
    addWatchViewController.isShowBackButton = YES;
    [self.navigationController pushViewController:addWatchViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
