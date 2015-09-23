//
//  LocationViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/6.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LocationViewController.h"


@interface LocationViewController ()
{
    NSTimer *timer;
    float count;
}

@property (nonatomic, strong) UIImageView *loadingView;

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    count = 0;
    self.title = @"定位";
    [self initUI];
    [self updateLocation];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addMapView];
    [self addTypeButton];
    [self addLocationButton];
    [self addZoomButton];
}

#pragma mark loading
- (void)addLoadingView
{
    if (!_loadingView)
    {
        UIImage *image = [UIImage imageNamed:@"loading"];
        float width = image.size.width/3 * CURRENT_SCALE;
        float height = image.size.height/3 * CURRENT_SCALE;
        float x = (self.view.frame.size.width - width)/2;
        float y = (self.view.frame.size.height - height)/2;
        _loadingView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, width, height) placeholderImage:image];
        [self.view addSubview:_loadingView];
    }
    [self createTimer];
}

- (void)createTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(moveLoadingView) userInfo:nil repeats:YES];
}

- (void)moveLoadingView
{
    count++;
    [UIView animateWithDuration:0.1 animations:^
    {
        _loadingView.transform = CGAffineTransformMakeRotation(count * M_PI_4);
    }];
}

#pragma mark 定位按钮事件
- (void)locationButtonPressed:(UIButton *)sender
{
    [self updateLocation];
}


- (void)updateLocation
{
    //__weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = (imeiNo) ? imeiNo : @"";
    NSString *urlString = [NSString stringWithFormat:@"%@?imeiNo=%@",UPDATE_LOCATION_URL,imeiNo];
    NSLog(@"====%@",urlString);
    [[RequestTool alloc] getRequestWithUrl:urlString
                         requestParamas:nil
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_LOCATION_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         //0:成功 401.1 账号或密码错误 404 账号不存在
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         //description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             //[SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_LOCATION_error====%@",error);
         //[SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
    
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
