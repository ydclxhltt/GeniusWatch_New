//
//  LeftViewController.m
//  GeniusWatch
//
//  Created by clei on 15/8/21.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "RightViewController.h"
#import "SettingViewController.h"
#import "TelephoneChargeViewController.h"
#import "LinkManListViewController.h"
#import "MessageListViewController.h"
#import "AfterServiceViewController.h"

#define SPACE_Y       100.0 * CURRENT_SCALE
#define TITLE_HEIGHT  20.0
#define ADD_Y         20.0 * CURRENT_SCALE

@interface RightViewController ()
{
    NSArray *titleArray;
}
@end

@implementation RightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addBgImageView];
    [self addButtons];
}

//添加背景图
- (void)addBgImageView
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) placeholderImage:[UIImage imageNamed:(SCREEN_HEIGHT == 480.0) ? @"left_bg1" : @"left_bg2"]];
    [self.view addSubview:imageView];
}

//添加功能按钮
- (void)addButtons
{
    titleArray = @[@"通讯录",@"消息记录",@"手机话费",@"APP设置",@"问题与反馈"];
    NSArray *imageArray = @[@"set_linkman",@"set_infomation",@"set_charge",@"set_set",@"set_feedback"];
    UIImage *image = [UIImage imageNamed:[imageArray[0] stringByAppendingString:@"_up"]];
    float buttonHeight = image.size.height/3 * CURRENT_SCALE;
    float buttonWidth = image.size.width/3 * CURRENT_SCALE;
    for (int i = 0; i < [titleArray count]; i++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(self.view.frame.size.width - RIGHT_SIDE_WIDTH + (RIGHT_SIDE_WIDTH - buttonWidth)/2, SPACE_Y + i * (buttonHeight + TITLE_HEIGHT + ADD_Y), buttonWidth, buttonHeight) buttonImage:imageArray[i] selectorName:@"buttonPressed:" tagDelegate:self];
        button.tag = i + 1;
        [self.view addSubview:button];
        
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(self.view.frame.size.width - RIGHT_SIDE_WIDTH, button.frame.size.height + button.frame.origin.y, RIGHT_SIDE_WIDTH, TITLE_HEIGHT) textString:titleArray[i] textColor:[UIColor whiteColor] textFont:FONT(14.0)];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}

#pragma mark 点击功能按钮响应事件
- (void)buttonPressed:(UIButton *)sender
{
    int tag = (int)sender.tag;
    UIViewController *viewController;
    switch (tag)
    {
        
        case 1:
            viewController = [[LinkManListViewController alloc] init];
            break;
        case 2:
            viewController = [[MessageListViewController alloc] init];
            break;
        case 3:
            viewController = [[TelephoneChargeViewController alloc] init];
            break;
        case 4:
            viewController = [[SettingViewController alloc] init];
            break;
        case 5:
            viewController = [[AfterServiceViewController alloc] init];
            break;
        default:
            break;
    }
    
    if (viewController)
    {
        viewController.title = titleArray[tag - 1];
        [self.navigationController pushViewController:viewController animated:YES];
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
