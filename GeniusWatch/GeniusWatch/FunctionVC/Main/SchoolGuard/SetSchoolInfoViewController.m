//
//  SetSchoolInfoViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/18.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetSchoolInfoViewController.h"
#import "AddressViewController.h"
#import "CLPickerView.h"

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
#define PICKERVIEW_HEIGHT   200.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y      10.0
#define BUTTON_SPACE_X      20.0 * CURRENT_SCALE
//更新
#define LOADING             @"更新中..."
#define LOADING_SUCESS      @"更新成功"
#define LOADING_FAIL        @"更新失败"

@interface SetSchoolInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) CLPickerView *clPickerView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSMutableArray *amArray;
@property (nonatomic, strong) NSMutableArray *pmArray;
@property (nonatomic, strong) NSMutableDictionary *tempDataDic;

@end

@implementation SetSchoolInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"学校";
    [self addBackItem];
    if (self.isSetClassTime)
    {
        self.titleArray = @[@[@"上学时间:",@"星期:"],@[]];
    }
    else
    {
        self.titleArray = @[@[@"地址:"],@[@"上学时间:",@"星期:"],@[]];
    }
    self.weekArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    [self initUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addButtons];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height -  BUTTON_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.scrollEnabled = NO;
}


- (void)addButtons
{
    if (!self.isSetClassTime)
    {
        UIButton *saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, self.view.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"保存" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"saveButtonPressed:" tagDelegate:self];
        saveButton.titleLabel.font = BUTTON_FONT;
        [CommonTool clipView:saveButton withCornerRadius:BUTTON_RADIUS];
        [self.view addSubview:saveButton];
    }
    
    _controlButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonImage:nil selectorName:@"controlButtonPressed:" tagDelegate:self];
    _controlButton.backgroundColor = RGBA(.0, .0, .0, .3);
    _controlButton.hidden = YES;
    [self.view addSubview:_controlButton];
}

#pragma mark 初始化数据
- (void)initData
{
    if (self.isSetClassTime)
    {
        NSString *amTime = self.dataDic[@"classTimeAm"];
        amTime = amTime ? amTime : @"";
        _amArray = [NSMutableArray arrayWithArray:[amTime componentsSeparatedByString:@"-"]];
        NSString *pmTime = self.dataDic[@"classTimePm"];
        pmTime = pmTime ? pmTime : @"";
        _pmArray = [NSMutableArray arrayWithArray:[pmTime componentsSeparatedByString:@"-"]];
    }
    else
    {
        self.tempDataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
        NSString *amStartTime = NO_NULL(self.tempDataDic[@"owner"][@"classDate"][@"amStartTime"]);
        NSString *amEndTime = NO_NULL(self.tempDataDic[@"owner"][@"classDate"][@"amEndTime"]);
        NSString *pmStartTime = NO_NULL(self.tempDataDic[@"owner"][@"classDate"][@"pmStartTime"]);
        NSString *pmEndTime = NO_NULL(self.tempDataDic[@"owner"][@"classDate"][@"pmEndTime"]);
        _amArray = [NSMutableArray arrayWithArray:@[amStartTime,amEndTime]];
        _pmArray = [NSMutableArray arrayWithArray:@[pmStartTime,pmEndTime]];
    }
    [self.table reloadData];
}

- (void)setDataWithTime:(NSDate *)time forIndex:(int)selectedIndex
{
     NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"HH:mm"];
     NSString *dateString = [formatter stringFromDate:time];
    int index = selectedIndex % 2;
    [(selectedIndex < 2) ? self.amArray : self.pmArray replaceObjectAtIndex:index withObject:dateString];
    if (self.isSetClassTime)
    {
        [self.dataDic setObject:[self.amArray componentsJoinedByString:@"-"] forKey:@"classTimeAm"];
        [self.dataDic setObject:[self.pmArray componentsJoinedByString:@"-"] forKey:@"classTimePm"];
    }
    else
    {
        NSArray *keyArray = @[@"amStartTime",@"amEndTime",@"pmStartTime",@"pmEndTime"];
        NSMutableDictionary *ownerDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"owner"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:ownerDic[@"classDate"]];
        [dic setValue:dateString forKey:keyArray[selectedIndex]];
        [ownerDic setValue:dic  forKey:@"classDate"];
        [self.tempDataDic setValue:ownerDic forKey:@"owner"];
    }
    
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

#pragma mark 选择时间按钮
- (void)timeButtonPressed:(UIButton *)sender
{
    [self addPickerViewWithIndex:(int)sender.tag];
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
                             [weakSelf setDataWithTime:date forIndex:selectedIndex];
                             [weakSelf.table reloadData];
                             [weakSelf movePickerViewIsShow:NO];
                         }
                                                cancelBlock:^
                         {
                             [weakSelf movePickerViewIsShow:NO];
                         }];
    }
    [self.view addSubview:_clPickerView];
    [weakSelf movePickerViewIsShow:YES];
    
}

#pragma mark 星期按钮事件
- (void)weekDayButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    int index = (int)sender.tag - 100;
    NSMutableDictionary *ownerDic = [NSMutableDictionary dictionaryWithDictionary:(self.isSetClassTime) ? self.dataDic : self.tempDataDic[@"owner"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:ownerDic[@"classDate"]];
    NSString *weekday = NO_NULL(dic[@"weekday"]);
    weekday = [weekday stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:[NSString stringWithFormat:@"%d",sender.selected]];
    [dic setValue:weekday forKey:@"weekday"];
    [ownerDic setValue:dic forKey:@"classDate"];
    [(self.isSetClassTime) ? self.dataDic : self.tempDataDic setValue:ownerDic forKey:@"owner"];
}

#pragma mark 保存
- (void)saveButtonPressed:(UIButton *)sender
{
    [self setGuardInfo];
}

#pragma mark 设置守护
- (void)setGuardInfo
{
    [SVProgressHUD showWithStatus:LOADING];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = (imeiNo) ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"mobileNo":[GeniusWatchApplication shareApplication].userName,@"schoolLngLat":self.tempDataDic[@"owner"][@"schoolLngLat"],@"schoolPoi":self.tempDataDic[@"owner"][@"schoolPoi"],@"schoolFence":self.tempDataDic[@"owner"][@"schoolFence"],@"classDate":self.tempDataDic[@"owner"][@"classDate"],@"homeLngLat":self.tempDataDic[@"owner"][@"homeLngLat"],@"homePoi":self.tempDataDic[@"owner"][@"homePoi"],@"homeFence":self.tempDataDic[@"owner"][@"homeFence"],@"homeLatestTime":self.tempDataDic[@"owner"][@"homeLatestTime"]};
    [[RequestTool alloc] requestWithUrl:SET_GUARD_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"SET_GUARD_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [weakSelf.dataDic setValue:weakSelf.tempDataDic[@"owner"] forKey:@"owner"];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
                            requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"SET_GUARD_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
    
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
    if (self.isSetClassTime)
    {
        if (indexPath.row == 0)
        {
            return ROW_HEIGHT1;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
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
    if (self.isSetClassTime)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0 && !self.isSetClassTime)
    {
        NSString *schoolAddress = NO_NULL(self.dataDic[@"owner"][@"schoolPoi"]);
        cell.textLabel.text = [@"地址:" stringByAppendingString:schoolAddress];
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
            float buttonWidth = (self.view.frame.size.width - 2 * LABEL_SPACE_X - LABEL_WIDTH - TIP_LABEL_WIDTH - 2 * LABEL_ADD_X - LINE_WIDTH)/2;
            for (int i = 0; i < [array count]; i++ )
            {
                NSString *leftString = @"";
                NSString *rightString = @"";
                NSMutableArray *timeArray = i == 0 ? self.amArray : self.pmArray;
                if (timeArray && [timeArray count] == 2)
                {
                    leftString = timeArray[0];
                    rightString = timeArray[1];
                }
                
                float x = lable.frame.size.width + lable.frame.origin.x + LABEL_ADD_X;
                float y = LABEL_SPACE_Y + i * (LABEL_ADD_Y + height);
                UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, TIP_LABEL_WIDTH, height) textString:array[i] textColor:TIP_COLOR textFont:TIP_FONT];
                [cell.contentView addSubview:tipLabel];
                
                x += tipLabel.frame.size.width + LABEL_ADD_X;
                UIButton *leftButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, buttonWidth, height) buttonTitle:leftString titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"timeButtonPressed:" tagDelegate:self];
                leftButton.tag = i * 2;
                [CommonTool setViewLayer:leftButton withLayerColor:[UIColor grayColor] bordWidth:.5];
                [CommonTool clipView:leftButton withCornerRadius:BUTTON_RADIUS];
                [cell.contentView addSubview:leftButton];
                
                x += leftButton.frame.size.width;
                UILabel *lineLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, LINE_WIDTH, height) textString:@"-" textColor:[UIColor blackColor] textFont:FONT(15.0)];
                lineLabel.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lineLabel];
                
                x += lineLabel.frame.size.width;
                UIButton *rightButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, buttonWidth, height) buttonTitle:rightString titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"timeButtonPressed:" tagDelegate:self];
                [CommonTool setViewLayer:rightButton withLayerColor:[UIColor grayColor] bordWidth:.5];
                [CommonTool clipView:rightButton withCornerRadius:BUTTON_RADIUS];
                rightButton.tag = i * 2 + 1;
                [cell.contentView addSubview:rightButton];
            }

        }
        if (indexPath.row == 1)
        {
            CGRect frame = lable.frame;
            lable.frame = CGRectMake(frame.origin.x, frame.origin.y, 50.0, lableHeight);
            
            NSString *weekString = NO_NULL(self.dataDic[@"owner"][@"classDate"][@"weekday"]);
            
            for (int i = 0; i < [self.weekArray count]; i++)
            {
                float x = lable.frame.size.width + lable.frame.origin.x + i * (WEEK_WH + WEEK_ADD_X);
                float y = (ROW_HEIGHT - WEEK_WH)/2;
                UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, WEEK_WH, WEEK_WH) buttonTitle:self.weekArray[i] titleColor:[UIColor blackColor] normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"weekDayButtonPressed:" tagDelegate:self];
                [CommonTool clipView:button withCornerRadius:CGRectGetWidth(button.frame)/2];
                [CommonTool setViewLayer:button withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                button.tag = 100 + i;
                button.titleLabel.font = FONT(15.0);
                [cell.contentView addSubview:button];
                
                if (weekString.length == 7)
                {
                    button.selected = [[weekString substringWithRange:NSMakeRange(i,1)] intValue];
                }
                
            }
        }
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isSetClassTime)
    {
        return;
    }
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        addressViewController.addressType = SetAddressTypeSchool;
        addressViewController.dataDic = self.dataDic;
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
