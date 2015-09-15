//
//  AboutWatchViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/14.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AboutWatchViewController.h"
#import "LeftRightLableCell.h"
#import "WatchVersionViewController.h"

//二维码
#define SCANNING_VIEW_WH     130.0 * CURRENT_SCALE
#define SPACE_Y              15.0
#define INFO_LABEL_HEIGHT    20.0
#define TIP_LABEL_HEIGHT     20.0
#define FIRST_CELL_HEIGHT    SCANNING_VIEW_WH + SPACE_Y + INFO_LABEL_HEIGHT + TIP_LABEL_HEIGHT + 5.0
//按钮
#define BUTTON_SPACE_X       20.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y       10.0


@interface AboutWatchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *bgView;
}
@property (nonatomic, strong) UILabel *infoLable;
@property (nonatomic, strong) UIImageView *scanningView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *headerHeightArray;

@end

@implementation AboutWatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于手表";
    [self addBackItem];
    
    self.headerHeightArray = @[@(0.0),@(2.0),@(5.0),@(20.0)];
    self.titleArray = @[@[@"扫一扫,绑定手表"],@[@"手表绑定号"],@[@"手表固件版本",@"手表运营商",@"型号"],@[@"GPS",@"WIFI",@"三轴传感器"]];
    NSArray *array = @[@[],@[@"zritaohrgcnqecah"],@[@"2.01",@"中国移动",@"Y01"],@[@"主要用于室外定位",@"主要用于室内定位",@"用于体感接听"]];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    
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
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - BUTTON_HEIGHT - 2 * BUTTON_SPACE_Y) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addButton
{
    UIButton *revokeButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, self.view.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"解除绑定" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"revokeButtonPressed:" tagDelegate:self];
    revokeButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:revokeButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:revokeButton];
}


- (void)addScanningViewToView:(UIView *)contentView
{
    if (!bgView)
    {
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        bgView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, width, height) placeholderImage:nil];
        
        _scanningView = [CreateViewTool createImageViewWithFrame:CGRectMake((width - SCANNING_VIEW_WH)/2, SPACE_Y, SCANNING_VIEW_WH, SCANNING_VIEW_WH) placeholderImage:nil];
        _scanningView.backgroundColor = APP_MAIN_COLOR;
        [bgView addSubview:_scanningView];
        
        start_y = _scanningView.frame.size.height + _scanningView.frame.origin.y;
        _infoLable = [CreateViewTool createLabelWithFrame:CGRectMake(0, start_y, width, INFO_LABEL_HEIGHT) textString:@"宝贝的二维码" textColor:TIP_COLOR textFont:FONT(12.0)];
        _infoLable.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_infoLable];
        
        start_y += _infoLable.frame.size.height;
        UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, start_y, width, TIP_LABEL_HEIGHT) textString:@"扫一扫,绑定手表" textColor:[UIColor blackColor] textFont:TIP_FONT];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:tipLabel];

    }
    
    [contentView addSubview:bgView];
}


#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return FIRST_CELL_HEIGHT;
    }
    return 44.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.headerHeightArray[section] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self.headerHeightArray[section] floatValue]) textString:(section == 3) ? @"  配置" : @"" textColor:SECTION_LABEL_COLOR textFont:FONT(12.0)];
    label.backgroundColor = SECTION_HEADER_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    static NSString *lfCellID = @"lfCellID";
    
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (bgView)
        {
            [bgView removeFromSuperview];
        }
        
        [self addScanningViewToView:cell.contentView];
        
        return cell;
    }
    else
    {
        LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:lfCellID];
        if (!cell)
        {
            cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lfCellID];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 2 && indexPath.row == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
        
        return cell;
    }

    

    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        WatchVersionViewController *watchVersionViewController = [[WatchVersionViewController alloc] init];
        [self.navigationController pushViewController:watchVersionViewController animated:YES];
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
