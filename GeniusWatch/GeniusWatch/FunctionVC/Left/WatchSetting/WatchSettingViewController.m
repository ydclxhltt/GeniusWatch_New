//
//  WatchSettingViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "WatchSettingViewController.h"
#import "LeftRightLableCell.h"
#import "LightTimeViewController.h"
#import "SoundSharkViewController.h"
#import "AutoPowerOffViewController.h"
#import "SetSchoolInfoViewController.h"
#import "AutoLinkManListViewController.h"

//提示
#define TIP_STRING           @"设置修改后,手表网络良好会自动同步,生效后APP会收到消息提醒."
#define SPACE_X              20.0 * CURRENT_SCALE
#define ADD_X                SPACE_X
#define TIP_LABEL_HEIGHT     50.0
//表
#define HEADER_HEIGHT        30.0
//按钮
#define BUTTON_SPACE_X       20.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y       10.0
//获取信息
#define LOADING             @"加载中..."
#define LOADING_SUCESS      @"加载成功"
#define LOADING_FAIL        @"加载失败"
//更新信息
#define LOADING_INFO         @"更新中..."
#define LOADING_INFO_SUCESS  @"更新成功"
#define LOADING_INFO_FAIL    @"更新失败"

@interface WatchSettingViewController ()

@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *autoContactArray;
@property (nonatomic, strong) NSMutableArray *noAutoContactArray;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSString *autoContactStr;
@property (nonatomic, strong) NSString *classTimeStr;
@property (nonatomic, strong) NSString *autoPowerOffStr;
@property (nonatomic, strong) NSString *secondStr;

@end

@implementation WatchSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手表设置";
    [self addBackItem];
    
    self.headerArray = @[@"  个性通话",@"  远程控制",@"  声音和显示"];
    self.titleArray = @[@[@"自动接通",@"报告通话位置",@"体感接听",@"预留应急电量"],@[@"上课禁用",@"定时开关机",@"拒绝默认人来电"],@[@"亮屏时间",@"声音和振动"]];
    _dataArray = [[NSMutableArray alloc] init];
    self.autoContactStr = @"";
    self.secondStr = @"";
    [self initUI];
    [self getWatchSettings];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataDic)
    {
        [self makeWatchSettingData:self.dataDic];
    }
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTipView];
    [self addTableView];
    [self addButton];
}

- (void)addTipView
{
    UIImage *image = [UIImage imageNamed:@"tip"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    UIImageView *iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(SPACE_X, NAVBAR_HEIGHT +(TIP_LABEL_HEIGHT - height)/2, width, height) placeholderImage:image];
    [self.view addSubview:iconImageView];
    
    float x = iconImageView.frame.size.width + iconImageView.frame.origin.x + ADD_X;
    float lable_width = self.view.frame.size.width - x - SPACE_X;
    
    UILabel *tipLable = [CreateViewTool  createLabelWithFrame:CGRectMake(x, NAVBAR_HEIGHT, lable_width, TIP_LABEL_HEIGHT) textString:TIP_STRING textColor:TIP_COLOR textFont:TIP_FONT];
    tipLable.numberOfLines = 2;
    [self.view addSubview:tipLable];
    
    start_y = tipLable.frame.size.height + tipLable.frame.origin.y;
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, self.view.frame.size.height - BUTTON_HEIGHT - 2 * BUTTON_SPACE_Y - start_y) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addButton
{
    _saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, self.view.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"保存" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"saveButtonPressed:" tagDelegate:self];
    _saveButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:_saveButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:_saveButton];
}

#pragma mark 获取开关信息
- (void)getWatchSettings
{
    //WATCH_SETTING_URL
    [SVProgressHUD showWithStatus:LOADING];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = imeiNo ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo};
    [[RequestTool alloc] requestWithUrl:WATCH_SETTING_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"WATCH_SETTING_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [weakSelf makeWatchSettingData:responseDic];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"WATCH_SETTING_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];

}

#pragma mark 设置数据
- (void)makeWatchSettingData:(NSDictionary *)dataDic
{
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    _keyArray = @[@"autoAcceptCallSwitch",@"bodyAcceptCallSwitch",@"reportCallPoiSwitch",@"keepUrgentPowerSwitch",@"classTimeDisabled",@"schedulePowerOffSwitch",@"refuseStrangerSwitch"];
    for (int i = 0; i < [_keyArray count]; i++)
    {
        [self.dataArray addObject:dataDic[_keyArray[i]]];
    }
    
    NSString *poweroffTime = dataDic[@"poweroffTime"];
    poweroffTime = poweroffTime ? poweroffTime : @"";
    NSString *poweronTime = dataDic[@"poweronTime"];
    poweronTime = poweronTime ? poweronTime : @"";
    self.autoPowerOffStr = [NSString stringWithFormat:@"开机:%@  关机:%@",poweronTime,poweroffTime];
   
    NSString *classTimeAm = dataDic[@"classTimeAm"];
    classTimeAm = classTimeAm ? classTimeAm : @"";
    NSString *classTimePm = dataDic[@"classTimePm"];
    classTimePm = classTimePm ? classTimePm : @"";
    self.classTimeStr = [NSString stringWithFormat:@"%@  %@",classTimeAm,classTimePm];
    
    int second = [dataDic[@"lightScreenDuration"] intValue];
    self.secondStr = [NSString stringWithFormat:@"%d秒",second];
    
    [self setAutoContactsWithArray:dataDic[@"autoCall"]];
    [self.table reloadData];
}

- (void)setAutoContactsWithArray:(NSArray *)array
{
    _autoContactArray = [[NSMutableArray alloc] init];
    _noAutoContactArray = [[NSMutableArray alloc] init];
    NSLog(@"array===%@",array);
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array)
    {
        NSString *autoCall = dic[@"allowAutoAcceptCall"];
        if (autoCall && ![autoCall isKindOfClass:[NSNull class]])
        {
            if ([autoCall integerValue] == 1)
            {
                NSString *name = dic[@"nickName"];
                name = name ? name : @"";
                [nameArray addObject:name];
                
            }
        }
        int userType = [dic[@"userType"] intValue];
        if (userType <= 2)
        {
            [_autoContactArray addObject:dic];
        }
        else
        {
            [_noAutoContactArray addObject:dic];
        }
        
    }
    self.autoContactStr = [nameArray componentsJoinedByString:@","];
    if ([nameArray count] > 3)
    {
        self.autoContactStr = [self.autoContactStr stringByAppendingString:[NSString stringWithFormat:@"(等%d人)",(int)[nameArray count]]];
    }
    NSLog(@"self.autoContactStr===%@====nameArray===%@",self.autoContactStr,nameArray
          );
}

#pragma mark 保存按钮
- (void)saveButtonPressed:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:LOADING_INFO];
    //__weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = self.dataDic;
    [[RequestTool alloc] requestWithUrl:UPDATE_WATCH_SETTING_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_WATCH_SETTING_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_INFO_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_INFO_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_WATCH_SETTING_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_INFO_FAIL];
     }];
    
}


#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headerArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT) textString:self.headerArray[section] textColor:SECTION_LABEL_COLOR textFont:FONT(14.0)];
    label.backgroundColor = SECTION_HEADER_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    static NSString *lfCellID = @"lfCellID";
    
    if (indexPath.section != 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = FONT(16.0);
        }
        
        UISwitch *switchView = [[UISwitch alloc] init];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        int index = (int)(indexPath.section * 4 + indexPath.row);
        switchView.tag = index + 1;
        
        if (self.dataArray && [self.dataArray count] > index)
        {
            switchView.on = [self.dataArray[index] integerValue];
        }
        cell.accessoryView = switchView;
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                cell.detailTextLabel.text = self.autoContactStr;
            }
            if (indexPath.row == 3)
            {
                cell.detailTextLabel.text = @"延长了待机时间,仅能接听家人电话";
            }
            
        }
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                cell.detailTextLabel.text = self.classTimeStr;
            }
            if (indexPath.row == 1)
            {
                cell.detailTextLabel.text = self.autoPowerOffStr;
            }
            
        }
        cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
        
        return cell;
    }
    else
    {
        LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:lfCellID];
        if (!cell)
        {
            cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lfCellID];
            cell.backgroundColor = [UIColor clearColor];
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSString *text = (indexPath.row == 0) ? self.secondStr : @"";
        [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:text];
        
        return cell;
    }
    
     return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        AutoLinkManListViewController *autoLinkManListViewController = [[AutoLinkManListViewController alloc] init];
        autoLinkManListViewController.autoArray = self.autoContactArray;
        autoLinkManListViewController.noAutoArray = self.noAutoContactArray;
        autoLinkManListViewController.dataDic = self.dataDic;
        [self.navigationController pushViewController:autoLinkManListViewController animated:YES];
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            SetSchoolInfoViewController *classTimeViewController = [[SetSchoolInfoViewController alloc] init];
            classTimeViewController.isSetClassTime = YES;
            classTimeViewController.dataDic = self.dataDic;
            [self.navigationController pushViewController:classTimeViewController animated:YES];
        }
        if (indexPath.row == 1)
        {
            AutoPowerOffViewController *autoPowerOffViewController = [[AutoPowerOffViewController alloc] init];
            autoPowerOffViewController.dataDic = self.dataDic;
            [self.navigationController pushViewController:autoPowerOffViewController animated:YES];
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            LightTimeViewController *lightTimeViewController = [[LightTimeViewController alloc] init];
            lightTimeViewController.defultTimeStr = self.secondStr;
            lightTimeViewController.dataDic = self.dataDic;
            [self.navigationController pushViewController:lightTimeViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            SoundSharkViewController *soundSharkViewController = [[SoundSharkViewController alloc] init];
            soundSharkViewController.dataDic = self.dataDic;
            [self.navigationController pushViewController:soundSharkViewController animated:YES];
        }
    }
}


#pragma mark 修改开关
- (void)switchChanged:(UISwitch *)switchView
{
    int index = (int)switchView.tag - 1;
    NSString *key= self.keyArray[index];
    NSString *value = [NSString stringWithFormat:@"%d",switchView.isOn];
    [self.dataDic setObject:value forKey:key];
    [self.dataArray replaceObjectAtIndex:index withObject:value];
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
