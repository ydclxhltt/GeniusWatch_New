//
//  TelephoneChargeViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#define IMAGEVIEW_HEIGHT   55.0
#define ADD_X              10.0 * CURRENT_SCALE

#import "TelephoneChargeViewController.h"

@interface TelephoneChargeViewController ()

@end

@implementation TelephoneChargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addButtons];
}


- (void)addButtons
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - IMAGEVIEW_HEIGHT, self.view.frame.size.width, IMAGEVIEW_HEIGHT) placeholderImage:nil];
    imageView.backgroundColor = APP_MAIN_COLOR;
    [self.view addSubview:imageView];
    
    float line_space_y = 5.0;
    float line_width = 1.0;
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(imageView.frame.size.width/2 - line_width/2, line_space_y, line_width, imageView.frame.size.height - 2 * line_space_y) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:lineImageView];
    
  
    float button_width = imageView.frame.size.width/2;
    float button_height = imageView.frame.size.height;
    NSArray *titleArray = @[@"查流量",@"查话费"];
    NSArray *imageArray = @[@"charge_stream",@"charge_pay"];

    
    for (int i = 0; i < [titleArray count]; i++)
    {
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        float image_height = image.size.height/3 * CURRENT_SCALE;
        float image_width = image.size.width/3 * CURRENT_SCALE;
        float title_width = [titleArray[i] sizeWithAttributes:@{NSFontAttributeName : BUTTON_FONT}].width;
        float space_x = (button_width - ADD_X - image_width - title_width)/2;
        float space_y = (button_height - image_height)/2;
        
        UIImageView *iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(space_x + i * button_width, space_y, image_width, image_height) placeholderImage:image borderColor:nil imageUrl:nil];
        [imageView addSubview:iconImageView];
        
        UILabel *titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + ADD_X , 0, title_width, button_height) textString:titleArray[i] textColor:BUTTON_TITLE_COLOR textFont:BUTTON_FONT];
        [imageView addSubview:titleLabel];
        
        UIButton *button = [CreateViewTool  createButtonWithFrame:CGRectMake(i * button_width, 0, button_width, button_height) buttonTitle:nil titleColor:nil normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"chargeButtonPressed:" tagDelegate:self];
        button.showsTouchWhenHighlighted = YES;
        [imageView addSubview:button];
    }
}


#pragma mark 按钮响应时间
- (void)chargeButtonPressed:(UIButton *)sender
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
