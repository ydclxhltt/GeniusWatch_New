//
//  AutoPowerOffViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AutoPowerOffViewController.h"
#import "LeftRightLableCell.h"
#import "CLPickerView.h"

#define SPACE_X             10.0
#define SPACE_Y             15.0
#define LABEL_HEIGHT        50.0
#define TIP_TEXT            @"注意:充电时,手表会一直保持开机状态,定时开关机不会生效."
#define PICKERVIEW_HEIGHT   200.0 * CURRENT_SCALE

@interface AutoPowerOffViewController ()

@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) CLPickerView *clPickerView;

@end

@implementation AutoPowerOffViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"开关机时间";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma  mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addFooterView];
    [self addbutton];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addFooterView
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, LABEL_HEIGHT) placeholderImage:nil];
    UILabel *tipLable = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, imageView.frame.size.width - 2 * SPACE_X, LABEL_HEIGHT) textString:TIP_TEXT textColor:TIP_COLOR textFont:TIP_FONT];
    tipLable.numberOfLines = 2;
    [imageView addSubview:tipLable];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:TIP_TEXT];
    [CommonTool makeString:TIP_TEXT toAttributeString:string withString:@"注意:" withTextColor:APP_MAIN_COLOR withTextFont:TIP_FONT];
    tipLable.attributedText = string;
    
    self.table.tableFooterView = imageView;
}


- (void)addbutton
{
    _controlButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonImage:nil selectorName:@"controlButtonPressed:" tagDelegate:self];
    _controlButton.backgroundColor = RGBA(.0, .0, .0, .3);
    _controlButton.hidden = YES;
    [self.view addSubview:_controlButton];
}


#pragma mark 控制按钮事件
- (void)controlButtonPressed:(UIButton *)sender
{
    sender.hidden = YES;
    [self movePickerViewIsShow:NO];
}

- (void)movePickerViewIsShow:(BOOL)isShow
{
    float y = (isShow) ? self.view.frame.size.height -  PICKERVIEW_HEIGHT : self.view.frame.size.height;
    CGRect frame = self.clPickerView.frame;
    frame.origin.y = y;
    self.controlButton.hidden = !isShow;
    [UIView animateWithDuration:.3 animations:^
     {
         self.clPickerView.frame = frame;
     }];
}

#pragma mark 添加pickView
- (void)addPickerViewWithIndex:(int)selectedIndex
{
    if (_clPickerView)
    {
        _clPickerView = nil;
    }
    __weak typeof(self) weakSelf = self;
    CGRect frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, PICKERVIEW_HEIGHT);
    {
        _clPickerView = [[CLPickerView alloc] initWithFrame:frame pickerViewType:PickerViewTypeOnlyTime sureBlock:^(UIDatePicker *pickerView, NSDate *date)
                         {
                             NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:@"HH:mm"];
                             NSString *dateString = [formatter stringFromDate:date];
                             NSString *key = (selectedIndex == 0) ? @"poweronTime" : @"poweroffTime";
                             [weakSelf.dataDic setObject:dateString forKey:key];
                             NSLog(@"weakSelf.dataDic==%@",weakSelf.dataDic);
                             [weakSelf.table reloadData];
                             [weakSelf movePickerViewIsShow:NO];
                         }
                         cancelBlock:^
                         {
                             [weakSelf movePickerViewIsShow:NO];
                         }];
        [_clPickerView setPickViewMaxDate];
    }
    [self.view addSubview:_clPickerView];
    [weakSelf movePickerViewIsShow:YES];
    
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(0, SPACE_X, 0, 0);
    }

    NSString *poweroffTime = self.dataDic[@"poweroffTime"];
    poweroffTime = (poweroffTime) ? poweroffTime : @"";
    NSString *poweronTime = self.dataDic[@"poweronTime"];
    poweronTime = (poweronTime) ? poweronTime : @"";
    [cell setDataWithLeftText:(indexPath.row == 0) ? @"开机时间" : @"关机时间" rightText:(indexPath.row == 0) ? poweronTime : poweroffTime];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self addPickerViewWithIndex:(int)indexPath.row];
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
