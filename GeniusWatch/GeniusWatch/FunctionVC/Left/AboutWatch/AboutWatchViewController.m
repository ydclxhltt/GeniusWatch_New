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
#import "AddWatchViewController.h"
#import "CreateQrcodeTool.h"

//二维码
#define SCANNING_VIEW_WH     130.0 * CURRENT_SCALE
#define SPACE_Y              15.0
#define INFO_LABEL_HEIGHT    20.0
#define TIP_LABEL_HEIGHT     20.0
#define FIRST_CELL_HEIGHT    SCANNING_VIEW_WH + SPACE_Y + INFO_LABEL_HEIGHT + TIP_LABEL_HEIGHT + 5.0
//按钮
#define BUTTON_SPACE_X       20.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y       10.0
//loading
#define LOADING              @"解除中..."
#define LOADING_SUCESS       @"已解除"
#define LOADING_FAIL         @"接触失败"
//获取基本信息
#define LOADING_INFO         @"加载中..."
#define LOADING_INFO_SUCESS  @"加载成功"
#define LOADING_INFO_FAIL    @"加载失败"

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
    [self getWatchBasicInfo];
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
        //_scanningView.backgroundColor = APP_MAIN_COLOR;
        [bgView addSubview:_scanningView];
        
        
        NSDictionary *dic = [GeniusWatchApplication shareApplication].currentDeviceDic;
        NSString *name = dic[@"owner"][@"ownerName"];
        name = name ? [name stringByAppendingString:@"的二维码"] : @"  的二维码";
        start_y = _scanningView.frame.size.height + _scanningView.frame.origin.y;
        _infoLable = [CreateViewTool createLabelWithFrame:CGRectMake(0, start_y, width, INFO_LABEL_HEIGHT) textString:name textColor:TIP_COLOR textFont:FONT(12.0)];
        _infoLable.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_infoLable];
        
        start_y += _infoLable.frame.size.height;
        UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, start_y, width, TIP_LABEL_HEIGHT) textString:@"扫一扫,绑定手表" textColor:[UIColor blackColor] textFont:TIP_FONT];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:tipLabel];

    }
    
    [contentView addSubview:bgView];
}

#pragma mark 获取设备基本信息
- (void)getWatchBasicInfo
{
    [SVProgressHUD showWithStatus:LOADING_INFO];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = imeiNo ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo};
    [[RequestTool alloc] requestWithUrl:WATCH_INFO_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"WATCH_INFO_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_INFO_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [weakSelf makeWatchBasicData:responseDic];
             [SVProgressHUD showSuccessWithStatus:LOADING_INFO_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"WATCH_INFO_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_INFO_FAIL];
     }];
}

#pragma mark 设置数据
- (void)makeWatchBasicData:(NSDictionary *)dataDic
{
    NSMutableArray *descArray = [NSMutableArray arrayWithArray:[dataDic[@"deviceDesc"] componentsSeparatedByString:@","]];
    if (descArray && [descArray count] == 3)
    {
        [descArray replaceObjectAtIndex:0 withObject:[descArray[0] stringByReplacingOccurrencesOfString:@"GPS:" withString:@""]];
        [descArray replaceObjectAtIndex:1 withObject:[descArray[1] stringByReplacingOccurrencesOfString:@"WIFI:" withString:@""]];
        [descArray replaceObjectAtIndex:2 withObject:[descArray[2] stringByReplacingOccurrencesOfString:@"三轴传感器:" withString:@""]];
    }
    NSArray *array = @[@[],@[dataDic[@"imeiNo"]],@[dataDic[@"version"],dataDic[@"mobileExecutor"],dataDic[@"modelNo"]],descArray];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self.table reloadData];
    
    self.scanningView.image = [CreateQrcodeTool createQrcodeWithString:dataDic[@"imeiNo"] imageSize:self.scanningView.frame.size.width redColor:0.0 greenColor:0.0 blueColor:0.0];

}


#pragma mark 接触绑定
- (void)revokeButtonPressed:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:LOADING];
    __weak typeof(self) weakSelf = self;
    NSString *binder = [GeniusWatchApplication shareApplication].userName;
    binder = binder ? binder : @"";
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = imeiNo ? imeiNo : @"";
    NSDictionary *requestDic = @{@"binder":binder,@"imeiNo":imeiNo,@"type":@"1"};
    [[RequestTool alloc] requestWithUrl:REVOKE_WATCH_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"REVOKE_WATCH_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         //0:成功 401.1 账号或密码错误 404 账号不存在
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             NSArray *devicesArray = ([dic[@"bind"][@"devices"] isKindOfClass:[NSNull class]]) ? nil : dic[@"bind"][@"devices"];
             [weakSelf updateDataWithDevice:devicesArray];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"REVOKE_WATCH_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
}

- (void)updateDataWithDevice:(NSArray *)deviceArray
{
    if (!deviceArray || [deviceArray count] == 0)
    {
        [self addWatch];
    }
    else
    {
        [GeniusWatchApplication shareApplication].deviceList = [NSMutableArray arrayWithArray:deviceArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoverFlow" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)addWatch
{
    AddWatchViewController *addWatchViewController = [[AddWatchViewController alloc] init];
    addWatchViewController.isShowBackButton = NO;
    addWatchViewController.showType = ShowTypePresent;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addWatchViewController];
    [self presentViewController:nav animated:YES completion:^{}];
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
        
        NSString *rightText = @"";
        if (self.dataArray)
        {
            rightText = self.dataArray[indexPath.section][indexPath.row];
        }
        [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:rightText];
        
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
