//
//  SetHouseInfoViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/18.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetHouseInfoViewController.h"
#import "AddressViewController.h"

#define BUTTON_SPACE_Y      10.0
#define BUTTON_SPACE_X      20.0 * CURRENT_SCALE
#define ROW_HEIGHT          55.0
#define LABEL_WIDTH         100.0
#define LABEL_SPACE_X       10.0
#define LABEL_TEXT          @"最晚到家时间:"
#define BUTTON_WIDTH        80.0
#define BUTTON_ADD_X        30.0

@interface SetHouseInfoViewController ()

@property (nonatomic, strong) UIButton *timeButton;

@end

@implementation SetHouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"家-小区";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addButton];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 2 * BUTTON_SPACE_Y - BUTTON_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addButton
{
    UIButton *saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, self.view.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"保存" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"saveButtonPressed:" tagDelegate:self];
    saveButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:saveButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:saveButton];
}


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"地址:广东省深圳市宝安区西乡街道...";
        cell.textLabel.font = FONT(15.0);
    }
    else
    {
        UILabel *lable = [CreateViewTool createLabelWithFrame:CGRectMake(LABEL_SPACE_X, 0, LABEL_WIDTH, ROW_HEIGHT) textString:LABEL_TEXT textColor:[UIColor blackColor] textFont:FONT(15.0)];
        [cell.contentView addSubview:lable];
        
        if (!self.timeButton)
        {
            float x = lable.frame.origin.x + lable.frame.size.width + BUTTON_ADD_X;
            _timeButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, (ROW_HEIGHT - BUTTON_HEIGHT)/2, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"18:00" titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"" tagDelegate:self];
            [CommonTool setViewLayer:_timeButton withLayerColor:[UIColor grayColor] bordWidth:.5];
            [CommonTool clipView:_timeButton withCornerRadius:BUTTON_RADIUS];
            [cell.contentView addSubview:_timeButton];
        }
    }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        addressViewController.addressType = SetAddressTypeHouse;
        [self.navigationController pushViewController:addressViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
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
