//
//  GuardSchoolViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#define LABEL_SPACE_Y       5.0 * CURRENT_SCALE
#define LABEL_SPACE_X       10.0 * CURRENT_SCALE
#define LABELVIEW_HEIGHT    50.0 * CURRENT_SCALE
//
#define POINT_SPACE_X       15.0 * CURRENT_SCALE
#define POINT_SPACE_Y       10.0 * CURRENT_SCALE
//按钮
#define BUTTON_SPACE_X      20.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y      10.0

#import "SchoolGuardViewController.h"
#import "AddressViewController.h"

@interface SchoolGuardViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SchoolGuardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"校园守护";
    [self addBackItem];
    [self setNavBarItemWithTitle:@"        设置" navItemType:RightItem selectorName:@"settingGuardInfo:"];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addLables];
    [self addScrollView];
    [self addButton];
}

- (void)addLables
{
    start_y = LABEL_SPACE_Y + NAVBAR_HEIGHT;
    float width = self.view.frame.size.width - 2 * LABEL_SPACE_X;
    float height = (LABELVIEW_HEIGHT - 2 * LABEL_SPACE_Y)/2;
    _addressLabel = [CreateViewTool createLabelWithFrame:CGRectMake(LABEL_SPACE_X, start_y, width, height) textString:@"广东省深圳市宝安区西乡街道1000路" textColor:TIP_COLOR textFont:TIP_FONT];
    [self.view addSubview:_addressLabel];
    
    start_y += _addressLabel.frame.size.height;
    _timeLable = [CreateViewTool createLabelWithFrame:CGRectMake(LABEL_SPACE_X, start_y, width, height) textString:@"守护时间段: 13:00 - 14:30; 16:00 - 18:00" textColor:TIP_COLOR textFont:FONT(13.0)];
    [self.view addSubview:_timeLable];
    
    start_y += _timeLable.frame.size.height + LABEL_SPACE_Y;
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, .5) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
}

- (void)addScrollView
{
    
}

- (void)addButton
{
    _switchButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, self.view.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"开启守护" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"switchButtonPressed:" tagDelegate:self];
    _switchButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:_switchButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:_switchButton];
    
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, _switchButton.frame.origin.y - BUTTON_SPACE_Y, self.view.frame.size.width, .5) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
}

#pragma mark 设置按钮
- (void)settingGuardInfo:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"守护信息设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"学校信息",@"家-小区信息",nil];
    [actionSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2)
    {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        addressViewController.addressType = (buttonIndex == 0) ? SetAddressTypeSchool : SetAddressTypeHouse;
        [self.navigationController pushViewController:addressViewController animated:YES];
    }
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
