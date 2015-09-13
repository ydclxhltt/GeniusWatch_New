//
//  SettingViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"

#define ROW_HEIGHT      50.0
#define HEADER_HEIGHT   2.0
#define SPACE_X         30.0 * CURRENT_SCALE
#define SPACE_Y         30.0

#define LOADING         @"正在退出..."
#define LOADING_SUCESS  @"退出成功"
#define LOADING_FAIL    @"退出失败"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = @[@"消息通知",@"修改密码",@"清除缓存",@"关于"];
    self.imageArray = @[@"app_set_after_information",@"app_set_after_password",@"app_set_after_eliminate",@"app_set_after_app"];
    
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addExitButton];
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ROW_HEIGHT * [self.imageArray count] + NAVBAR_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    [self.table setScrollEnabled:NO];
    
    start_y = self.table.frame.origin.y + self.table.frame.size.height + SPACE_Y;
}

- (void)addExitButton
{
    UIButton *exitButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"退出登录" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:nil selectorName:@"registerButtonPressed:" tagDelegate:self];
    exitButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:exitButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:exitButton];
    
}

#pragma mark 退出登录
- (void)registerButtonPressed:(UIButton *)sender
{
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING];
    NSString *url = [NSString stringWithFormat:@"%@?mobileNo=%@",EXIT_URL,[GeniusWatchApplication shareApplication].userName];
    [[RequestTool alloc] getRequestWithUrl:url
                         requestParamas:nil
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
                         {
                             NSLog(@"EXIT_URL===%@",responseDic);
                             NSDictionary *dic = (NSDictionary *)responseDic;
                             //0:成功 1:失败
                             NSString *errorCode = dic[@"errorCode"];
                             NSString *description = dic[@"description"];
                             description = (description) ? description : LOADING_FAIL;
                             if ([@"0" isEqualToString:errorCode])
                             {
                                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
                                 [weakSelf goToLogin];
                             }
                             else
                             {
                                 [SVProgressHUD showErrorWithStatus:description];
                             }
                         }
                         requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
                         {
                             NSLog(@"EXIT_URL——error===%@",error);
                             [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
                         }];
 }


- (void)goToLogin
{
    [GeniusWatchApplication shareApplication].isLaunchLogin = NO;
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.isShowBackItem = NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:nav animated:YES completion:^
     {
         [self.navigationController popToRootViewControllerAnimated:NO];
     }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.transform = CGAffineTransformMakeScale(.5, .5);
        cell.backgroundColor = [UIColor whiteColor];
    }

    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = FONT(15.0);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
