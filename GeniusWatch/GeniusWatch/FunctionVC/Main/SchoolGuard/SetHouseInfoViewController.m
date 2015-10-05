//
//  SetHouseInfoViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/18.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetHouseInfoViewController.h"
#import "AddressViewController.h"
#import "CLPickerView.h"

#define BUTTON_SPACE_Y      10.0
#define BUTTON_SPACE_X      20.0 * CURRENT_SCALE
#define ROW_HEIGHT          55.0
#define LABEL_WIDTH         100.0
#define LABEL_SPACE_X       10.0
#define LABEL_TEXT          @"最晚到家时间:"
#define BUTTON_WIDTH        80.0
#define BUTTON_ADD_X        30.0
#define PICKERVIEW_HEIGHT   200.0 * CURRENT_SCALE
//更新
#define LOADING             @"更新中..."
#define LOADING_SUCESS      @"更新成功"
#define LOADING_FAIL        @"更新失败"

@interface SetHouseInfoViewController ()

@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) CLPickerView *clPickerView;
@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) NSMutableDictionary *tempDataDic;

@end

@implementation SetHouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"家-小区";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tempDataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
    [self.table reloadData];
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
    
    _controlButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonImage:nil selectorName:@"controlButtonPressed:" tagDelegate:self];
    _controlButton.backgroundColor = RGBA(.0, .0, .0, .3);
    _controlButton.hidden = YES;
    [self.view addSubview:_controlButton];
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
    [self addPickerView];
}

#pragma mark 添加pickView
- (void)addPickerView
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
                             NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.tempDataDic[@"owner"]];
                             [dic setObject:dateString forKey:@"homeLatestTime"];
                             [weakSelf.tempDataDic setObject:dic forKey:@"owner"];
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
        NSLog(@"self.dataDic==%@",self.dataDic);
        NSString *homeAddress = NO_NULL(self.dataDic[@"owner"][@"homePoi"]);
        cell.textLabel.text = [@"地址:" stringByAppendingString:homeAddress];
        cell.textLabel.font = FONT(15.0);
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else
    {
        UILabel *lable = [CreateViewTool createLabelWithFrame:CGRectMake(LABEL_SPACE_X, 0, LABEL_WIDTH, ROW_HEIGHT) textString:LABEL_TEXT textColor:[UIColor blackColor] textFont:FONT(15.0)];
        [cell.contentView addSubview:lable];
        NSString *time = NO_NULL(self.tempDataDic[@"owner"][@"homeLatestTime"]);
        if (!self.timeButton)
        {
            
            float x = lable.frame.origin.x + lable.frame.size.width + BUTTON_ADD_X;
            _timeButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, (ROW_HEIGHT - BUTTON_HEIGHT)/2, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:time titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"timeButtonPressed:" tagDelegate:self];
            [CommonTool setViewLayer:_timeButton withLayerColor:[UIColor grayColor] bordWidth:.5];
            [CommonTool clipView:_timeButton withCornerRadius:BUTTON_RADIUS];
        }
        [cell.contentView addSubview:_timeButton];
        [_timeButton setTitle:time forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        addressViewController.dataDic = self.dataDic;
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
