//
//  SetSchoolInfoViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/18.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetSchoolInfoViewController.h"
#import "AddressViewController.h"

#define ROW_HEIGHT          55.0
#define ROW_HEIGHT1         110.0
#define LABEL_WIDTH         80.0
#define LABEL_SPACE_X       10.0
#define LABEL_ADD_X         10.0
#define LABEL_SPACE_Y       10.0
#define LABEL_ADD_Y         10.0
#define TIP_LABEL_WIDTH     40.0
#define LINE_WIDTH          20.0 * CURRENT_SCALE
#define WEEK_WH             30.0
#define WEEK_ADD_X          10.0

@interface SetSchoolInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *weekArray;

@end

@implementation SetSchoolInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"学校";
    [self addBackItem];
    self.titleArray = @[@[@"地址:"],@[@"上学时间:",@"星期:"],@[]];
    self.weekArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height -  BUTTON_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.scrollEnabled = NO;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return ROW_HEIGHT1;
    }
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0 : 10.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, tableView.frame.size.width, (section == 0) ? 0 : 10.0) placeholderImage:nil];
    imageView.backgroundColor = SECTION_HEADER_COLOR;
    return imageView;
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
    
    cell.accessoryType = (indexPath.section == 0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectionStyle = (indexPath.section == 0) ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"地址:广东省深圳市宝安区西乡街道...";
        cell.textLabel.font = FONT(15.0);
    }
    else
    {
        float lableHeight = (indexPath.row == 0) ? ROW_HEIGHT1 : ROW_HEIGHT;
        UILabel *lable = [CreateViewTool createLabelWithFrame:CGRectMake(LABEL_SPACE_X, 0, LABEL_WIDTH, lableHeight) textString:self.titleArray[indexPath.section][indexPath.row] textColor:[UIColor blackColor] textFont:FONT(15.0)];
        [cell.contentView addSubview:lable];
        
        if (indexPath.row == 0)
        {
            NSArray *array = @[@"上午:",@"下午:"];

            float height = (ROW_HEIGHT1 - (LABEL_SPACE_Y * 2 + LABEL_ADD_Y))/2;
            float buttonWidth = (cell.frame.size.width - 2 * LABEL_SPACE_X - LABEL_WIDTH - TIP_LABEL_WIDTH - 2 * LABEL_ADD_X - LINE_WIDTH)/2;
            for (int i = 0; i < [array count]; i++ )
            {
                float x = lable.frame.size.width + lable.frame.origin.x + LABEL_ADD_X;
                float y = LABEL_SPACE_Y + i * (LABEL_ADD_Y + height);
                UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, TIP_LABEL_WIDTH, height) textString:array[i] textColor:TIP_COLOR textFont:TIP_FONT];
                [cell.contentView addSubview:tipLabel];
                
                x += tipLabel.frame.size.width + LABEL_ADD_X;
                UIButton *leftButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, buttonWidth, height) buttonTitle:@"10:00" titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"" tagDelegate:self];
                [CommonTool setViewLayer:leftButton withLayerColor:[UIColor grayColor] bordWidth:.5];
                [CommonTool clipView:leftButton withCornerRadius:BUTTON_RADIUS];
                [cell.contentView addSubview:leftButton];
                
                x += leftButton.frame.size.width;
                UILabel *lineLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, LINE_WIDTH, height) textString:@"-" textColor:[UIColor blackColor] textFont:FONT(15.0)];
                lineLabel.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lineLabel];
                
                x += lineLabel.frame.size.width;
                UIButton *rightButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, buttonWidth, height) buttonTitle:@"10:00" titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"" tagDelegate:self];
                [CommonTool setViewLayer:rightButton withLayerColor:[UIColor grayColor] bordWidth:.5];
                [CommonTool clipView:rightButton withCornerRadius:BUTTON_RADIUS];
                [cell.contentView addSubview:rightButton];
                
            }

        }
        if (indexPath.row == 1)
        {
            CGRect frame = lable.frame;
            lable.frame = CGRectMake(frame.origin.x, frame.origin.y, 50.0, lableHeight);
            for (int i = 0; i < [self.weekArray count]; i++)
            {
                float x = lable.frame.size.width + lable.frame.origin.x + i * (WEEK_WH + WEEK_ADD_X);
                float y = (ROW_HEIGHT - WEEK_WH)/2;
                UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, WEEK_WH, WEEK_WH) buttonTitle:self.weekArray[i] titleColor:[UIColor blackColor] normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"" tagDelegate:self];
                [CommonTool clipView:button withCornerRadius:CGRectGetWidth(button.frame)/2];
                [CommonTool setViewLayer:button withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
                button.titleLabel.font = FONT(15.0);
                [cell.contentView addSubview:button];
            }
        }
        
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        addressViewController.addressType = SetAddressTypeHouse;
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
