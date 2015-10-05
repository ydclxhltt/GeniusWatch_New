//
//  MainViewController.m
//  GeniusWatch
//
//  Created by clei on 15/8/21.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "MainViewController.h"
#import "MainSideViewController.h"
#import "BMapKit.h"
#import "LocationViewController.h"
#import "SchoolGuardViewController.h"
#import "WeChatViewController.h"

//地图
#define MAP_SPACE_Y         240.0/2 * CURRENT_SCALE
#define MAP_SPACE_X         40.0 * CURRENT_SCALE
#define MAP_HEIGHT          580.0/2 * CURRENT_SCALE
//左右按钮
#define MENU_SPAXCE_Y       44.0
#define BABY_SPAXCE_Y       35.0
#define BABY_SPACE_X        20.0
#define MENU_SPACE_X        10.0
#define BABY_LAYER_COLOR    RGB(86.0,151.0,142.0)

//手表信息
#define BABY_INFO_HEIGHT    20.0 * CURRENT_SCALE
#define BABY_INFO_SPACE_X   390.0/3 * CURRENT_SCALE
#define BABY_LOC_SPACE_X    310.0/3 * CURRENT_SCALE
#define BABY_LOC_SPACE_Y    5.0 * CURRENT_SCALE
#define BABY_LOC_HEIGHT     115.0/3 * CURRENT_SCALE


@interface MainViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *geocodesearch;
    int currentDeviceIndex;
}

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *deviceArray;
@property (nonatomic, strong) UIImageView *bageImageView;
@property (nonatomic, strong) UILabel *safeLable;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _deviceArray = [NSMutableArray arrayWithArray:[GeniusWatchApplication shareApplication].deviceList];
    currentDeviceIndex = [GeniusWatchApplication shareApplication].currentDeviceIndex;
    if (self.deviceArray && [self.deviceArray count] > currentDeviceIndex)
    {
        self.dataDic = [NSMutableDictionary  dictionaryWithDictionary:self.deviceArray[currentDeviceIndex]];
    }
    
    //[self getReverseGeocodeWithLocation:[self getBabyLocation]];

    [self initUI];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAboutLocationDelegate:self];
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setAboutLocationDelegate:nil];
}

#pragma mark 设置定位/地图代理
- (void)setAboutLocationDelegate:(id)delegate
{
    if (_mapView)
        _mapView.delegate = delegate;
    if (geocodesearch)
    {
        geocodesearch.delegate = delegate;
    }
}

#pragma mark 初始化数据
- (void)initData
{
    CLLocationCoordinate2D coorfinate;
    if (self.dataDic)
    {
        [self.deviceArray replaceObjectAtIndex:currentDeviceIndex withObject:self.dataDic];
        NSDictionary *dic = self.dataDic[@"lastPosition"];
        NSLog(@"====%@",dic[@"poi"]);
        if (dic)
        {
            coorfinate = CLLocationCoordinate2DMake([dic[@"point"][@"lat"] floatValue], [dic[@"point"][@"lng"] floatValue]);
            NSDictionary *dict = BMKConvertBaiduCoorFrom(coorfinate,BMK_COORDTYPE_GPS);
            CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dict); // 转换为百度地图所需要的经纬度
            coorfinate = baiduCoor;
        }
        NSString *address = (dic[@"poi"]) ? dic[@"poi"] : @"";
        self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",[self getBabyLastTime],address];
    }

    [self setLocationCoordinate:coorfinate locationText:@""];
    
    NSString *iconUrl = @"";
    //= @"http://p1.qqyou.com/touxiang/UploadPic/2014-7/24/2014072412362223172.jpg";
    iconUrl = [self getBabyIcon];
    [_bageImageView setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"baby_head_up"]];
}

#pragma mark 获取头像
- (NSString *)getBabyIcon
{
    NSString *iconUrl = @"";
    if (self.deviceArray && [self.deviceArray count] > currentDeviceIndex)
    {
        NSDictionary *dic = self.deviceArray[currentDeviceIndex];
        iconUrl = dic[@"owner"][@"headShot"];
        iconUrl = (iconUrl) ? iconUrl : @"";
    }
    return iconUrl;
}

#pragma mark 获取坐标 
- (CLLocationCoordinate2D)getBabyLocation
{
    CLLocationCoordinate2D coorfinate;
    if (self.deviceArray && [self.deviceArray count] > currentDeviceIndex)
    {
        NSDictionary *dic = self.deviceArray[currentDeviceIndex][@"lastPosition"];
        NSLog(@"====%@",dic[@"poi"]);
        if (dic)
        {
            coorfinate = CLLocationCoordinate2DMake([dic[@"point"][@"lat"] floatValue], [dic[@"point"][@"lng"] floatValue]);
        }
    }
    return coorfinate;
}

#pragma mark 获取坐标
- (NSString *)getBabyLastTime
{
    NSString *timeStr = @"";
    if (self.deviceArray && [self.deviceArray count] > currentDeviceIndex)
    {
        NSDictionary *dic = self.deviceArray[currentDeviceIndex][@"lastPosition"];
        if (dic)
        {
            timeStr = dic[@"datetime"];
            timeStr = (timeStr) ? timeStr : @"";
            timeStr = [CommonTool getUTCFormateDate:timeStr];
        }
    }
    
    return timeStr;
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addMapView];
    [self addBgImageView];
    [self addMenuButtons];
    [self addInfoLables];
    [self addFunctionButtons];
}

//添加背景
- (void)addBgImageView
{
    
    NSArray *imageArray = @[@"top",@"middle",@"bottom"];
    float y = 0.0;
    for (int i = 0; i < [imageArray count]; i++)
    {
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        float width = image.size.width/3 * CURRENT_SCALE;
        float height = image.size.height/3 * CURRENT_SCALE;
        UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, width, height) placeholderImage:image];
        imageView.tag = i + 100;
        [self.view addSubview:imageView];
         y += height;
    }
}

//添加地图
- (void)addMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(MAP_SPACE_X, MAP_SPACE_Y, self.view.frame.size.width - 2 * MAP_SPACE_X, MAP_HEIGHT)];
    self.mapView.delegate = self;
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.zoomLevel = 15.0;
    self.mapView.showsUserLocation = NO;
    [self.view addSubview:self.mapView];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//                   ^{
//                       self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(MAP_SPACE_X, MAP_SPACE_Y, self.view.frame.size.width - 2 * MAP_SPACE_X, MAP_HEIGHT)];
//                       self.mapView.delegate = self;
//                       self.mapView.mapType = BMKMapTypeStandard;
//                       self.mapView.zoomLevel = 15.0;
//                       self.mapView.showsUserLocation = NO;
//                       dispatch_sync(dispatch_get_main_queue(), ^
//                       {
//                           [self.view insertSubview:self.mapView atIndex:0];
//
//                       });
//                    });
    
}

//添加菜单按钮
- (void)addMenuButtons
{
    UIImage *image = [UIImage imageNamed:@"homepage_more_up"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    UIButton *moreButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.view.frame.size.width - MENU_SPACE_X - width, MENU_SPAXCE_Y, width, height) buttonImage:@"homepage_more" selectorName:@"moreButtonPressed:" tagDelegate:self];
    [self.view addSubview:moreButton];
    
    
    UIImage *babyImage = [UIImage imageNamed:@"baby_head_up"];
    float babyWidth = babyImage.size.width/3 * CURRENT_SCALE;
    float babyHeight = babyImage.size.height/3 * CURRENT_SCALE;
    
    UIImageView *babyView = [CreateViewTool createImageViewWithFrame:CGRectMake(BABY_SPACE_X, BABY_SPAXCE_Y, babyWidth, babyHeight) placeholderImage:nil];
    [self.view addSubview:babyView];
    
    NSString *iconUrl = @"";
    //= @"http://p1.qqyou.com/touxiang/UploadPic/2014-7/24/2014072412362223172.jpg";
    iconUrl = [self getBabyIcon];
    
    _bageImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, babyWidth, babyHeight) placeholderImage:babyImage imageUrl:iconUrl isShowProcess:NO];
    [CommonTool setViewLayer:_bageImageView withLayerColor:[UIColor whiteColor] bordWidth:1.0];
    [CommonTool clipView:_bageImageView withCornerRadius:babyWidth/2];
    [babyView addSubview:_bageImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(babyImageViewPressed:)];
    [_bageImageView addGestureRecognizer:tapGesture];

    
    UIImage *cellImage = [UIImage imageNamed:@"homepage_cell"];
    float cellWidth = cellImage.size.width/3 * CURRENT_SCALE;
    float cellHeight = cellImage.size.height/3 * CURRENT_SCALE;
    UIImageView *cellImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(_bageImageView.frame.size.width - cellWidth, _bageImageView.frame.size.height - cellHeight, cellWidth, cellHeight) placeholderImage:cellImage];
    [babyView addSubview:cellImageView];
}

//添加手表信息视图
- (void)addInfoLables
{
    //上面的视图
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:100];
    
    _addressLabel = [CreateViewTool createLabelWithFrame:CGRectMake(BABY_LOC_SPACE_X, imageView.frame.size.height - BABY_LOC_HEIGHT, imageView.frame.size.width - 2 * BABY_LOC_SPACE_X, BABY_LOC_HEIGHT  - BABY_LOC_SPACE_Y) textString:@"正在获取地址..." textColor:[UIColor whiteColor] textFont:FONT(13.0)];
    _addressLabel.numberOfLines = 2;
    _addressLabel.adjustsFontSizeToFitWidth = YES;
    [imageView addSubview:_addressLabel];
    
    _safeLable = [CreateViewTool createLabelWithFrame:CGRectMake(BABY_INFO_SPACE_X, _addressLabel.frame.origin.y - BABY_INFO_HEIGHT, imageView.frame.size.width - 2 * BABY_INFO_SPACE_X, BABY_INFO_HEIGHT) textString:@"上学守护未开启" textColor:APP_MAIN_COLOR textFont:BOLD_FONT(14.0)];
    _safeLable.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:_safeLable];
}

//添加功能按钮
- (void)addFunctionButtons
{
    float add_y = 43.0  * CURRENT_SCALE;
    float space_y = 435.0 * CURRENT_SCALE;
    float space_phone_y = 487.0  * CURRENT_SCALE;
    
    UIImage *image = [UIImage imageNamed:@"homepage_location_up"];
    float vWidth = image.size.width/3 * CURRENT_SCALE;
    float vHeight = image.size.height/3 * CURRENT_SCALE;
    float space_vx = (self.view.frame.size.width - 2 * vWidth)/2;
    float space_vy = space_y + add_y;
        
    UIImage *schoolImage = [UIImage imageNamed:@"homepage_school_up"];
    float hWidth = schoolImage.size.width/3 * CURRENT_SCALE;
    float hHeight = schoolImage.size.height/3 * CURRENT_SCALE;
    float space_hx = (self.view.frame.size.width - hWidth)/2;
    float space_hy = space_y;
    
    UIImage *phoneImage = [UIImage imageNamed:@"homepage_phone_up"];
    float phoneWidth = phoneImage.size.width/3 * CURRENT_SCALE;
    float phoneHeight = phoneImage.size.height/3 * CURRENT_SCALE;
    float space_phone_x = (self.view.frame.size.width - phoneWidth)/2;
    
    NSValue *point1 = [NSValue valueWithCGRect:CGRectMake(space_hx, space_hy, hWidth, hHeight)];
    NSValue *point2 = [NSValue valueWithCGRect:CGRectMake(space_vx, space_vy, vWidth, vHeight)];
    NSValue *point3 = [NSValue valueWithCGRect:CGRectMake(space_vx + vWidth, space_vy, vWidth, vHeight)];
    NSValue *point4 = [NSValue valueWithCGRect:CGRectMake(space_phone_x, space_phone_y, phoneWidth, phoneHeight)];
    
    NSArray *pointArray = @[point1,point2,point3,point4];
    NSArray *imageArray = @[@"homepage_school",@"homepage_location",@"homepage_chat",@"homepage_phone"];
    
    for (int i = 0; i < [pointArray count]; i++)
    {
        CGRect frame = [pointArray[i] CGRectValue];
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) buttonImage:imageArray[i] selectorName:@"buttonPressed:" tagDelegate:self];
        button.tag = i + 1;
        [self.view addSubview:button];
    }
}


#pragma mark 点击头像按钮
- (void)babyImageViewPressed:(UITapGestureRecognizer *)tapGesture
{
    [[MainSideViewController sharedSliderController] showLeftViewController:YES];
}

#pragma mark 点击更多按钮
- (void)moreButtonPressed:(UIButton *)sender
{
    [[MainSideViewController sharedSliderController] showRightViewController:YES];
}

#pragma mark 点击功能按钮
- (void)buttonPressed:(UIButton *)sender
{
    int index = (int)sender.tag;
    
    UIViewController *viewController = nil;
    
    switch (index)
    {
        case 1:
            //守护
            viewController = [[SchoolGuardViewController alloc] init];
            ((SchoolGuardViewController *)viewController).dataDic = self.dataDic;
            break;
        case 2:
            //定位
            viewController = [[LocationViewController alloc] init];
            ((LocationViewController *)viewController).lastCoordinate = self.mapView.centerCoordinate;
            ((LocationViewController *)viewController).lastAddress = self.addressLabel.text;
            ((LocationViewController *)viewController).dataDic = self.dataDic;
            //viewController = [[BasicMapViewController alloc] init];
            break;
        case 3:
            //微聊
            viewController = [[WeChatViewController alloc] init];
            break;
        case 4:
            //电话
            [self makeCall];
            break;
            
        default:
            break;
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark 打电话
- (void)makeCall
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"15820790320"]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        //设备不支持
        [CommonTool addAlertTipWithMessage:@"设备不支持"];
    }
}


#pragma mark 编译地址
- (void)getReverseGeocodeWithLocation:(CLLocationCoordinate2D)locaotion
{
    NSLog(@"locaotion===%f===%f",locaotion.latitude,locaotion.longitude);
    if (!geocodesearch)
    {
        geocodesearch = [[BMKGeoCodeSearch alloc] init];
        geocodesearch.delegate = self;
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = locaotion;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


#pragma mark 坐标转换地址Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result====%@",[result  address]);
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",[self getBabyLastTime],[result  address]];
    [self setLocationCoordinate:result.location locationText:@""];
}



#pragma mark 添加地图标注
- (void)setLocationCoordinate:(CLLocationCoordinate2D)coordinate  locationText:(NSString *)location
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = location;
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
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_mapView)
    {
        _mapView = nil;
    }
    if (geocodesearch)
    {
        geocodesearch.delegate = nil;
        geocodesearch = nil;
    }
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
