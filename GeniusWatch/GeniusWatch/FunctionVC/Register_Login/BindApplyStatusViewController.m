//
//  BindApplyStatusViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/13.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BindApplyStatusViewController.h"

#define TIP_STRING1         @"您的申请信息已发送给手表管理员\n等待确认中..."
#define TIP_STRING2         @"您申请的信息  被管理员拒绝"
#define TIP_STRING3         @"您申请的信息已通过管理员的同意"
#define SPACE_Y             NAVBAR_HEIGHT + 30.0
#define TIPLABEL_HEIGHT     40.0
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0
#define SPACE_X             20.0 * CURRENT_SCALE

@interface BindApplyStatusViewController ()

@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *tipButton;

@end

@implementation BindApplyStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"等待确认";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTipImageView];
    [self addTipView];
    [self addButton];
}

- (void)addTipImageView
{
    UIImage *image = [UIImage imageNamed:@"send_sucess_up"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    
    _tipImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake((self.view.frame.size.width - width)/2, SPACE_Y, width, height) placeholderImage:image borderColor:nil imageUrl:nil];
    [self.view addSubview:_tipImageView];
    
    start_y = _tipImageView.frame.size.height + _tipImageView.frame.origin.y + ADD_Y;
}

- (void)addTipView
{
    _tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TIPLABEL_HEIGHT) textString:TIP_STRING1 textColor:TIP_COLOR textFont:TIP_FONT];
    _tipLabel.numberOfLines = 2;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tipLabel];
    
    start_y += _tipLabel.frame.size.height + BUTTON_ADD_Y;
}

- (void)addButton
{
    _tipButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"发送成功" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"tipButtonButtonPressed:" tagDelegate:self];
    _tipButton.selected = YES;
    [CommonTool clipView:_tipButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:_tipButton];
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
