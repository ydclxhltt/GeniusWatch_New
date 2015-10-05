//
//  LocationViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/6.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LocationViewController.h"

#define LABLE_HEIGHT            20.0
#define LABLE_WIDTH             80.0
#define ICONIMAGWVIEW_WH        40.0
#define TIPVIEW_HEIGHT          80.0
#define SPACE_Y                 10.0
#define SPACE_X                 20.0
#define ADD_X                   5.0

@interface LocationViewController ()
{
    NSTimer *timer;
    float count;
}

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *loadingView;

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    count = 0;
    self.title = @"定位";
    [self initUI];
    [self.mapView setCenterCoordinate:self.lastCoordinate animated:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTimer];
    self.locaitonButton.enabled = NO;
    [self updateLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissLoadingView];
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addMapView];
    [self addTypeButton];
    [self addLocationButton];
    [self addZoomButton];
    [self addTipViewWithType:0];
    
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
    _loadingView.hidden = NO;
}

#pragma mark tipView
//预留type
- (void)addTipViewWithType:(int)type
{
    UIImageView *bgView = (UIImageView *)[self.view viewWithTag:100];
    if (!bgView)
    {
        bgView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, TIPVIEW_HEIGHT) placeholderImage:nil];
        bgView.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.6);
        [self.view addSubview:bgView];
    }
    UIImageView *iconImageView = (UIImageView *)[bgView viewWithTag:101];
    if (!iconImageView)
    {
        iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(SPACE_X, SPACE_Y, ICONIMAGWVIEW_WH, ICONIMAGWVIEW_WH) placeholderImage:[UIImage imageNamed:@"location_wifi"] borderColor:nil imageUrl:nil];
        [bgView addSubview:iconImageView];
    }
    UILabel *label = (UILabel *)[bgView viewWithTag:102];
    if (!label)
    {
        label = [CreateViewTool createLabelWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height, LABLE_WIDTH, LABLE_HEIGHT) textString:@"定位位置" textColor:[UIColor whiteColor] textFont:FONT(14.0)];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
    }
    
    if (!_infoLabel)
    {
        float x = label.frame.origin.x + label.frame.size.width + ADD_X;
        float w = self.view.frame.size.width - x - SPACE_X;
        float h = bgView.frame.size.height - 2 * SPACE_Y;
        _infoLabel = [CreateViewTool createLabelWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + ADD_X, SPACE_Y, w, h) textString:@"正在更新位置...." textColor:[UIColor whiteColor] textFont:FONT(15.0)];
        //infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.numberOfLines = 3;
        [bgView addSubview:_infoLabel];
    }
}

- (void)moveLoadingView
{
    count++;
    [UIView animateWithDuration:0.1 animations:^
    {
        _loadingView.transform = CGAffineTransformMakeRotation(count * M_PI_4);
    }];
}

- (void)dismissLoadingView
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
    _loadingView.hidden = YES;
}


#pragma mark 定位按钮事件
- (void)locationButtonPressed:(UIButton *)sender
{
    self.locaitonButton.enabled = NO;
    [self updateLocation];
}


- (void)updateLocation
{
    [self addLoadingView];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = (imeiNo) ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo};
    [[RequestTool alloc] requestWithUrl:UPDATE_LOCATION_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         weakSelf.locaitonButton.enabled = YES;
         NSLog(@"UPDATE_LOCATION_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         //description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             //[SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf dismissLoadingView];
             [weakSelf makeDataWithDictionary:dic];
             //[weakSelf setLocationCoordinate:<#(CLLocationCoordinate2D)#> locationText:@""];
         }
         else
         {
             [weakSelf dismissLoadingView];
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_LOCATION_error====%@",error);
         weakSelf.locaitonButton.enabled = YES;
         [weakSelf dismissLoadingView];
         //[SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
    
}

#pragma mark 设置数据
- (void)makeDataWithDictionary:(NSDictionary *)dataDic
{
    CLLocationCoordinate2D coorfinate;
    if (dataDic)
    {
        coorfinate = CLLocationCoordinate2DMake([dataDic[@"point"][@"lat"] floatValue], [dataDic[@"point"][@"lng"] floatValue]);
        NSDictionary *dict = BMKConvertBaiduCoorFrom(coorfinate,BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dict); // 转换为百度地图所需要的经纬度
        coorfinate = baiduCoor;
    
        NSString *address = (dataDic[@"poi"]) ? dataDic[@"poi"] : @"";
        NSLog(@"address===%@",address);
        NSString *timeStr = dataDic[@"datetime"];
        timeStr = (timeStr) ? timeStr : @"";
        timeStr = [CommonTool getUTCFormateDate:timeStr];
        address = [address stringByAppendingString:timeStr];
        _infoLabel.text = address;
        
        NSDictionary *dic = @{@"datetime":dataDic[@"datetime"],@"poi":dataDic[@"poi"],@"point":dataDic[@"point"]};
        [self.dataDic setValue:dic forKey:@"lastPosition"];
    }
    
    [self setLocationCoordinate:coorfinate locationText:@""];
}

#pragma mark 添加地图标注
- (void)setLocationCoordinate:(CLLocationCoordinate2D)coordinate  locationText:(NSString *)location
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    //point.title = location;
    [self.mapView addAnnotation:point];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}


#pragma mark MapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.image = [UIImage imageNamed:@"location_icon"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    
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
