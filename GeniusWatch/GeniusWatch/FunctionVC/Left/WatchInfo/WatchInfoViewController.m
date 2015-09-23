//
//  WatchInfoViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "WatchInfoViewController.h"
#import "LeftRightLableCell.h"
#import "BabyIocnView.h"
#import "CLPickerView.h"

#define PICKERVIEW_HEIGHT    200.0 * CURRENT_SCALE

@interface WatchInfoViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *referLabel;
@property (nonatomic, strong) BabyIocnView *babyIocnView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *headerHeightArray;
@property (nonatomic, strong) CLPickerView *clPickerView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation WatchInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"宝贝资料";
    [self addBackItem];
    NSDictionary *dataDic = [GeniusWatchApplication shareApplication].currentDeviceDic;
    self.headerHeightArray = @[@(2.0),@(10.0),@(10.0)];
    self.titleArray = @[@[@"手表号码",@"手边短号/亲情号"],@[@"性别",@"生日",@"年级"],@[@"学校信息",@"家-小区信息"]];
    [self initUI];
    [self initDataWithDictionary:dataDic];
    [self getWatchInfo];
    // Do any additional setup after loading the view.
}

#pragma mark 返回按钮
- (void)backButtonPressed:(UIButton *)sender
{
    [self saveInfoChange];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 保存修改
- (void)saveInfoChange
{
    //UPDATE_OWNER_URL
    NSDictionary *requestDic = [GeniusWatchApplication shareApplication].currentDeviceDic;
//    [[RequestTool alloc] requestWithUrl:UPDATE_OWNER_URL
//                         requestParamas:requestDic
//                            requestType:RequestTypeAsynchronous
//                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
//     {
//         NSLog(@"UPDATE_OWNER_URL===%@",responseDic);
//         NSDictionary *dic = (NSDictionary *)responseDic;
//         //0:成功 401.1 账号或密码错误 404 账号不存在
//         NSString *errorCode = dic[@"errorCode"];
//         //NSString *description = dic[@"description"];
//         //description = (description) ? description : @"";
//         if ([@"0" isEqualToString:errorCode])
//         {
//             //[SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
//         }
//         else
//         {
//             //[SVProgressHUD showErrorWithStatus:description];
//         }
//     }
//     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"UPDATE_OWNER_URL_error====%@",error);
//         //[SVProgressHUD showErrorWithStatus:LOADING_FAIL];
//     }];
    
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer  serializer];
    //manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    AFHTTPRequestOperation *requestOperation =  [manager POST:UPDATE_OWNER_URL parameters:requestDic
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                         {
                                 UIImage *image = [UIImage imageNamed:@"default_icon"];
                                 NSData *data = UIImageJPEGRepresentation(image, .1);
                                 NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
                                 [formData appendPartWithFileData:data name:@"ownerHeadShot" fileName:[NSString stringWithFormat:@"%.0f.png",time] mimeType:@"image/png"];
                         }
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
                         {
                             NSLog(@"operationresponseObject===%@",operation.responseString);
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
                         {

                             NSLog(@"error===%@",error);
                         }];
    
    NSString *string = [[NSString alloc] initWithData:requestOperation.request.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"string===%@",string);
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addTableViewHeader];
    [self addbutton];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}


- (void)addTableViewHeader
{
    float space_y = 10.0;
    float space_x = 25.0 * CURRENT_SCALE;
    float add_x = 15.0;
    UIImage *babyImage = [UIImage imageNamed:@"baby_head_up"];
    float babyWidth = babyImage.size.width/3 * CURRENT_SCALE;
    float babyHeight = babyImage.size.height/3 * CURRENT_SCALE + INFO_LABLE_HEIGHT;
    
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, babyHeight + space_y) placeholderImage:nil];
    [self.table setTableHeaderView:bgImageView];
    
    _babyIocnView = [[BabyIocnView alloc] initWithFrame:CGRectMake(space_x, space_y, babyWidth, babyHeight)];
    [bgImageView addSubview:_babyIocnView];
    [_babyIocnView setImageWithUrl:nil defaultImage:@"baby_head_up" infoLableText:@"修改头像"];
    
    float x  = _babyIocnView.frame.origin.x + _babyIocnView.frame.size.width + add_x;
    float height = (babyHeight - INFO_LABLE_HEIGHT)/2;
    float width = bgImageView.frame.size.width - babyWidth - 2 * space_x - add_x;
    _nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, space_y, width, height) textString:@"" textColor:[UIColor blackColor] textFont:FONT(16.0)];
    [bgImageView addSubview:_nameLabel];
    
    float y = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    _referLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, width, height) textString:@"我与宝贝的关系是:" textColor:TIP_COLOR textFont:FONT(16.0)];
    [bgImageView addSubview:_referLabel];
    
}

- (void)addbutton
{
    _controlButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonImage:nil selectorName:@"controlButtonPressed:" tagDelegate:self];
    _controlButton.backgroundColor = RGBA(.0, .0, .0, .3);
    _controlButton.hidden = YES;
    [self.view addSubview:_controlButton];
}


#pragma mark 数据处理
- (void)initDataWithDictionary:(NSDictionary *)dic
{
    if (!dic)
    {
        return;
    }
    NSDictionary *ownerDic = dic[@"owner"];
    NSString *name = ownerDic[@"ownerName"];
    name = (name) ? name : @"";
    NSString *nickName = ownerDic[@"nickName"];
    nickName = (nickName) ? nickName : @"";
    self.nameLabel.text = name;
    self.referLabel.text = [@"我与宝贝的关系是:" stringByAppendingString:nickName];
    
    NSString *gender = ([@"M" isEqualToString:ownerDic[@"gender"]]) ? @"男" : @"女";
    NSArray *array  = @[@[ownerDic[@"mobileNo"],ownerDic[@"shortPhoneNo"]],@[gender,ownerDic[@"birthday"],ownerDic[@"grade"]],@[ownerDic[@"schoolPoi"],ownerDic[@"homePoi"]]];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self.table reloadData];
}


#pragma mark 获取数据
- (void)getWatchInfo
{
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = (imeiNo) ? imeiNo : @"";
    NSLog(@"====%@",OWNER_INFO_URL);
    NSDictionary *requestDic = @{@"imeiNo":imeiNo};
    [[RequestTool alloc] requestWithUrl:OWNER_INFO_URL
                            requestParamas:requestDic
                               requestType:RequestTypeAsynchronous
                             requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"OWNER_INFO_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         //0:成功 401.1 账号或密码错误 404 账号不存在
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         //description = (description) ? description : @"";
         if ([@"0" isEqualToString:errorCode])
         {
             //[SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf initDataWithDictionary:dic];
         }
         else
         {
             //[SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"OWNER_INFO_URL_error====%@",error);
         //[SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
}


#pragma mark 控制按钮事件
- (void)controlButtonPressed:(UIButton *)sender
{
    sender.hidden = YES;
    [self movePickerViewIsShow:NO];
}


#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    return [self.headerHeightArray[section] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self.headerHeightArray[section] floatValue]) textString:@"" textColor:SECTION_LABEL_COLOR textFont:FONT(12.0)];
    label.backgroundColor = SECTION_HEADER_COLOR;
    return label;
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
    }
        
    [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
        
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndexPath = indexPath;
    
    if (indexPath.section == 0)
    {
        [self addTipViewWithIndex:(int)indexPath.row];
    }
    
    if (indexPath.section == 1)
    {
        [self addPickerViewWithIndex:(int)indexPath.row];
    }

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
    NSArray *array = (selectedIndex == 0) ? @[@"男",@"女"] : @[@"还没上学",@"幼儿园小班",@"幼儿园中班",@"幼儿园大班",@"学龄前",@"小学一年级",@"小学二年级",@"小学三年级",@"小学四年级",@"小学五年级",@"小学六年级",@"其他"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[GeniusWatchApplication shareApplication].currentDeviceDic objectForKey:@"owner"]];
    if (selectedIndex == 0 || selectedIndex == 2)
    {
        _clPickerView = [[CLPickerView alloc] initWithFrame:frame pickerViewType:PickerViewTypeCustom customSureBlock:^(UIPickerView *pickView, int index)
        {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.dataArray[weakSelf.selectedIndexPath.section]];
            [tempArray replaceObjectAtIndex:selectedIndex withObject:array[index]];
            [weakSelf.dataArray replaceObjectAtIndex:1 withObject:tempArray];
            [weakSelf.table reloadData];
            NSString *key = (selectedIndex == 0) ? @"gender" : @"grade";
            [dic setObject:array[index] forKey:key];
            [[GeniusWatchApplication shareApplication].currentDeviceDic setObject:dic forKey:@"owner"];
            NSLog(@"[GeniusWatchApplication shareApplication].currentDeviceDic==%@",[GeniusWatchApplication shareApplication].currentDeviceDic);
            [weakSelf movePickerViewIsShow:NO];
        }
        cancelBlock:^
        {
            [weakSelf movePickerViewIsShow:NO];
        }
        pickerData:array];
    }
    else
    {
        _clPickerView = [[CLPickerView alloc] initWithFrame:frame pickerViewType:PickerViewTypeDate sureBlock:^(UIDatePicker *pickerView, NSDate *date)
        {
            NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [formatter stringFromDate:date];
            [dic setObject:dateString forKey:@"birthday"];
            [[GeniusWatchApplication shareApplication].currentDeviceDic setObject:dic forKey:@"owner"];
            NSLog(@"[GeniusWatchApplication shareApplication].currentDeviceDic==%@",[GeniusWatchApplication shareApplication].currentDeviceDic);
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.dataArray[weakSelf.selectedIndexPath.section]];
            [tempArray replaceObjectAtIndex:selectedIndex withObject:dateString];
            [weakSelf.dataArray replaceObjectAtIndex:1 withObject:tempArray];
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


#pragma mark 添加弹出框
- (void)addTipViewWithIndex:(int)index
{
    NSString *title = (index == 0) ? @"手表电话" : @"手表短号/亲情号";
    NSString *message = (index == 0) ? @"请设置手表电话号码" : @"请设置手表短号或亲情号";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100 + index;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    UITextField *textField = (UITextField *)[alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}


#pragma mark UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = (int)alertView.tag - 100;
    if (buttonIndex == 1)
    {
        UITextField *textField = (UITextField *)[alertView textFieldAtIndex:0];
        NSString *text = textField.text ? textField.text : @"";
        if (text.length == 0)
        {
            [self addTipViewWithIndex:index];
        }
        else
        {
            if (index == 0)
            {
                if ([CommonTool isEmailOrPhoneNumber:text])
                {
                    [self setDataWithIndex:0 text:text];
                }
                else
                {
                    [self addTipViewWithIndex:index];
                }
            }
            else
            {
                [self setDataWithIndex:1 text:text];
            }
        }
    }
}

- (void)setDataWithIndex:(int)index text:(NSString *)text
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[GeniusWatchApplication shareApplication].currentDeviceDic objectForKey:@"owner"]];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray[self.selectedIndexPath.section]];
    [tempArray replaceObjectAtIndex:index withObject:text];
    [self.dataArray replaceObjectAtIndex:0 withObject:tempArray];
    [self.table reloadData];
    NSString *key = (index == 0) ? @"mobileNo" : @"shortPhoneNo";
    [dic setObject:text forKey:key];
    [[GeniusWatchApplication shareApplication].currentDeviceDic setObject:dic forKey:@"owner"];
    NSLog(@"[GeniusWatchApplication shareApplication].currentDeviceDic==%@",[GeniusWatchApplication shareApplication].currentDeviceDic);
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
