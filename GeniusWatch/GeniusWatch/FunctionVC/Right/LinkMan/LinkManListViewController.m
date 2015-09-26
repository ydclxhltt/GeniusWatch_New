//
//  LinkManListViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LinkManListViewController.h"
#import "AddLinkManViewController.h"
#import "LinkManListCell.h"
#import "AddLinkManViewController.h"

#define SECTION_HEIGHT   10.0
#define HEADER_HEIGHT    120.0
#define ROW_HEIGHT       75.0

#define BUTTON_SPACE_X   20.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y   10.0
#define BUTTON_HEIGHT    40.0
#define FOOTER_HEIGHT    80.0

//获取联系人信息
#define LOADING_INFO         @"加载中..."
#define LOADING_INFO_SUCESS  @"加载成功"
#define LOADING_INFO_FAIL    @"加载失败"
//删除联系人信息
#define LOADING_DEL          @"正在删除..."
#define LOADING_DEL_SUCESS   @"删除成功"
#define LOADING_DEL_FAIL     @"删除失败"
//更新联系人信息
#define LOADING             @"更新短号..."
#define LOADING_SUCESS      @"更新成功"
#define LOADING_FAIL        @"更新失败"
//tip
#define SHORT_TIP           @"短号/亲情号:SIM卡之间办理的通话优惠套餐,可互相拨打3-6位数的短号进行通话.\n\n添加亲情/短号注意事项:\n同时添加手表短号和自己短号时,主界面拨号才会默认拨打短号.\n不支持添加两位数及以下短号.\n如填写短号不正确,可能会导致手表和APP无法正常拨号."
#define CONTACT_TIP         @"可能的原因和解决方法:\n\n*SIM卡未开通数据流量(手表时间界面未显示\"G\"),请开通流量套餐后关机重启手表;\n*新卡插入手表后,未重启.请重启手表后再使用;\n*手表网络不好(手表时间界面\"G\"闪),请稍等片刻或换个地方试试."



@interface LinkManListViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *watchOwnerLable;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *shortNumberLable;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation LinkManListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    self.title = @"通讯录";
    [self initUI];
    [self getLinkManList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContact) name:@"updateContact" object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addTableViewHeader];
    [self addButtons];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - FOOTER_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    //self.table.backgroundColor = SECTION_HEADER_COLOR;
}

- (void)addTableViewHeader
{
    float space_y  = 10.0;
    float space_x = 60.0 * CURRENT_SCALE;
    float add_x = 20.0 * CURRENT_SCALE;
    UIImage *iconImage = [UIImage imageNamed:@"watch_icon"];
    float iconWidth = iconImage.size.width/3 * CURRENT_SCALE;
    float iconHeight = iconImage.size.height/3 * CURRENT_SCALE;
    
    float height = iconHeight + 2 * space_y;
    
    UIImageView *imageView = [CreateViewTool  createImageViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height) placeholderImage:nil];
    imageView.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = imageView;
    
    UIImageView *iconBgView = [CreateViewTool createImageViewWithFrame:CGRectMake(space_x, space_y, iconWidth, iconHeight) placeholderImage:iconImage];
    [imageView addSubview:iconBgView];
    
    float icon_space_x = 4.0 * CURRENT_SCALE;
    float icon_space_y = 20.0 * CURRENT_SCALE;
    float icon_w = 36.0 * CURRENT_SCALE;
    float icon_h = 41.0 * CURRENT_SCALE;
    _iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(icon_space_x, icon_space_y, icon_w, icon_h) placeholderImage:nil];
    [iconBgView addSubview:_iconImageView];
    
    
    
    float x = iconBgView.frame.origin.x + iconBgView.frame.size.width + add_x;
    float y = iconBgView.frame.origin.y;
    float labelHeight = iconBgView.frame.size.height/3;
    float labelWidth = imageView.frame.size.width - x - space_x;
    _watchOwnerLable = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, labelWidth, labelHeight) textString:@"手表主人:" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [imageView addSubview:_watchOwnerLable];
    
    y += _watchOwnerLable.frame.size.height;
    
    _phoneNumberLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, labelWidth, labelHeight) textString:@"手表号码:" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [imageView addSubview:_phoneNumberLabel];
    
     y += _phoneNumberLabel.frame.size.height;
    _shortNumberLable = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, labelWidth, labelHeight) textString:@"短号/亲情号:" textColor:[UIColor blackColor]  textFont:FONT(15.0)];
    [imageView addSubview:_shortNumberLable];
    
}

- (void)addButtons
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - FOOTER_HEIGHT, CGRectGetWidth(self.view.frame), FOOTER_HEIGHT) placeholderImage:nil];
    [self.view addSubview:bgImageView];
    
    UIButton *addButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, bgImageView.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"添加联系人" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"addLinkManButtonPressed:" tagDelegate:self];
    addButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:addButton withCornerRadius:BUTTON_RADIUS];
    [bgImageView addSubview:addButton];
    
    float buttonWidth = bgImageView.frame.size.width/2;
    float buttonHeight = bgImageView.frame.size.height - addButton.frame.size.height -  BUTTON_SPACE_Y;
    NSArray *array = @[@"打不通电话?",@"同步不了联系人?"];
    for (int i = 0; i < 2; i++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight) buttonTitle:array[i] titleColor:[UIColor lightGrayColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"tipButtonPressed:" tagDelegate:self];
        button.tag = i + 1;
        button.titleLabel.font = FONT(12.0);
        [bgImageView addSubview:button];
    }
}

#pragma mark 获取联系人列表
- (void)getLinkManList
{
    [SVProgressHUD showWithStatus:LOADING_INFO];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = imeiNo ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo};
    [[RequestTool alloc] requestWithUrl:CONTACTS_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"CONTACTS_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_INFO_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
              [weakSelf setDataWithDictionary:dic];
             [SVProgressHUD showSuccessWithStatus:LOADING_INFO_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"CONTACTS_URL_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_INFO_FAIL];
     }];
}

- (void)setDataWithDictionary:(NSDictionary *)dic
{
    self.dataArray = [NSMutableArray arrayWithArray:dic[@"contacts"]];
    [self.table reloadData];
    
    NSDictionary *ownerDic = dic[@"owner"];
    NSString *name = ownerDic[@"ownerName"];
    name = name ? name : @"";
    NSString *mobile = ownerDic[@"mobileNo"];
    mobile = mobile ? mobile : @"";
    NSString *shortNumber = ownerDic[@"shortPhoneNo"];
    shortNumber = shortNumber ? shortNumber : @"";
    self.watchOwnerLable.text = [@"手表主人: " stringByAppendingString:name];
    self.phoneNumberLabel.text = [@"手表号码: " stringByAppendingString:mobile];
    self.shortNumberLable.text = [@"短号/亲情号: " stringByAppendingString:shortNumber];
    NSURL *imageUrl = [NSURL URLWithString:ownerDic[@"headShot"]];
    [self.iconImageView setImageWithURL:imageUrl placeholderImage:nil];
}

#pragma mark 提示按钮响应时间
- (void)tipButtonPressed:(UIButton *)sender
{
    NSString *title = (sender.tag == 1) ? @"什么是短号/亲情号" : @"同步不了联系人";
    NSString *message = (sender.tag == 1) ? SHORT_TIP : CONTACT_TIP;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertView.tag = 111;
    [alertView show];
}

#pragma mark 添加联系人
- (void)addLinkManButtonPressed:(UIButton *)sender
{
    AddLinkManViewController *addLinkManViewController = [[AddLinkManViewController alloc] init];
    addLinkManViewController.pushFor = PushForAdd;
    [self.navigationController pushViewController:addLinkManViewController animated:YES];
}


#pragma mark 更新联系人通知
- (void)updateContact
{
    [self getLinkManList];
}

#pragma mark UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), SECTION_HEIGHT) textString:@"" textColor:nil textFont:nil];
    label.backgroundColor =  SECTION_HEADER_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    LinkManListCell *cell = (LinkManListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LinkManListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    [cell setContactDataWithDictionary:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = (int)indexPath.row;
    [self addActionViewWithTag:(int)indexPath.row + 100];
}

#pragma mark 添加弹出视图
- (void)addActionViewWithTag:(int)tag
{
    NSDictionary *rowDic = self.dataArray[tag - 100];
    NSString *name = rowDic[@"nickName"];
    name = name ? name : @"";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:name delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑关系或名称",@"编辑短号/亲情号",@"删除", nil];
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = (int)actionSheet.tag - 100;
    NSDictionary *dic = self.dataArray[index];
    if (buttonIndex == 0)
    {
        AddLinkManViewController *addLinkManViewController = [[AddLinkManViewController alloc] init];
        addLinkManViewController.pushFor = PushForChange;
        addLinkManViewController.dataDic = dic;
        [self.navigationController pushViewController:addLinkManViewController animated:YES];
    }
    else if(buttonIndex == 1)
    {
        //短号
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"编辑短号/亲情号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
        
        NSString *shortNumber = dic[@"shortPhoneNo"];
        shortNumber = shortNumber ? shortNumber : @"";
        UITextField *textFiled = (UITextField *)[alertView textFieldAtIndex:0];
        textFiled.text = shortNumber;
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if(buttonIndex == 2)
    {
        //删除
        NSString *mobile = dic[@"mobileNo"];
        mobile = mobile ? mobile : @"";
        [self deleteContactWithMobile:mobile index:index];
    }
}

#pragma mark UIAlertViewDlegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *textFiled = [alertView textFieldAtIndex:0];
//        if (textFiled.text.length > 6 || textFiled.text.length < 3)
//        {
//            [CommonTool addAlertTipWithMessage:@"短号/亲情号是3-6位的数字"];
//            return;
//        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.selectedIndex]];
        NSString *shortNumber = dic[@"shortPhoneNo"];
        shortNumber = shortNumber ? shortNumber : @"";
        if (![shortNumber isEqualToString:textFiled.text])
        {
            [dic setValue:textFiled.text forKey:@"shortPhoneNo"];
            [self changeOwnerInfoWithDataDic:dic];
        }
    }
}


#pragma mark 更新联系人
- (void)changeOwnerInfoWithDataDic:(NSMutableDictionary *)dataDic
{
    [SVProgressHUD showWithStatus:LOADING];
    NSString *binder = [GeniusWatchApplication shareApplication].userName;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"contact":dataDic,@"binder":binder};
    __weak typeof(self) weakSelf = self;
    [[RequestTool alloc] requestWithUrl:UPDATE_CONTACT_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_CONTACT_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [weakSelf.dataArray replaceObjectAtIndex:self.selectedIndex withObject:dataDic];
             [weakSelf.table reloadData];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_CONTACT_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
}

#pragma mark 删除联系人
- (void)deleteContactWithMobile:(NSString *)mobile index:(int)index
{
    [SVProgressHUD showWithStatus:LOADING_DEL];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = imeiNo ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"mobileNo":mobile,@"binder":[GeniusWatchApplication shareApplication].userName};
    [[RequestTool alloc] requestWithUrl:DEL_CONTACTS_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"DEL_CONTACTS_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         //0:成功 401.1 账号或密码错误 404 账号不存在
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_DEL_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [weakSelf.dataArray removeObjectAtIndex:index];
             [weakSelf.table reloadData];
             [SVProgressHUD showSuccessWithStatus:LOADING_DEL_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"DEL_CONTACTS_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_INFO_FAIL];
     }];
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

