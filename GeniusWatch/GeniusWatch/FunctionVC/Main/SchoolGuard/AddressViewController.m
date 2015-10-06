//
//  AddressViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddressViewController.h"
#import "OutSideAddressViewController.h"

#define TIPVIEW_HEIGHT  120.0 * CURRENT_SCALE
//更新
#define LOADING             @"更新中..."
#define LOADING_SUCESS      @"更新成功"
#define LOADING_FAIL        @"更新失败"

@interface AddressViewController ()

@property (nonatomic, strong) NSMutableDictionary *tempDataDic;
@property (nonatomic, assign) float fenceValue;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, assign) CLLocationCoordinate2D searchCoordinate;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = (self.addressType == SetAddressTypeHouse) ? @"设置家—小区区域" : @"设置学校区域";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initUI];
    self.tempDataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark 搜索
- (void)searchButtonPressed
{
    OutSideAddressViewController *outSideAddressViewController = [[OutSideAddressViewController alloc] init];
    outSideAddressViewController.searchCoordinate = self.searchCoordinate;
    outSideAddressViewController.addressType = self.addressType;
    outSideAddressViewController.dataDic = self.tempDataDic;
    [self.navigationController pushViewController:outSideAddressViewController animated:YES];
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addMapView];
    [self addLocationButton];
    [self addZoomButton];
    [self addTypeButton];
    [self addTipView];
    self.locaitonButton.hidden = YES;
}

- (void)addTipView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - TIPVIEW_HEIGHT, self.view.frame.size.width, TIPVIEW_HEIGHT) placeholderImage:nil];
    bgImageView.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.6);
    [self.view addSubview:bgImageView];
    
    float label_height = 20.0;
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, bgImageView.frame.size.width, label_height) textString:[NSString stringWithFormat:@" 请点选 %@ 的中心位置", (self.addressType == SetAddressTypeHouse) ? @"家-小区" : @"学校"] textColor:[UIColor whiteColor] textFont:FONT(13.0)];
    [bgImageView addSubview:label];
    
    float add_y = 5.0;
    float y = label.frame.origin.y + label.frame.size.height + add_y;
    label_height = 40.0;
    float space_x = 20.0;
    _addressLabel = [CreateViewTool createLabelWithFrame:CGRectMake(space_x, y, bgImageView.frame.size.width - 2 * space_x, label_height) textString:@"" textColor:[UIColor whiteColor] textFont:FONT(15.0)];
    _addressLabel.numberOfLines = 2;
    [bgImageView addSubview:_addressLabel];
    
    y += _addressLabel.frame.size.height + add_y;
    space_x = 45.0 * CURRENT_SCALE;
    UIButton *saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, y, self.view.frame.size.width - 2 * space_x, BUTTON_HEIGHT) buttonTitle:@"保存" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"saveButtonPressed:" tagDelegate:self];
    saveButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:saveButton withCornerRadius:BUTTON_RADIUS];
    [bgImageView addSubview:saveButton];
}

#pragma mark 初始化数据
- (void)initData
{
    self.fenceValue = (self.addressType == SetAddressTypeHouse) ? [self.tempDataDic[@"owner"][@"homeFence"] floatValue] : [self.tempDataDic[@"owner"][@"schoolFence"] floatValue];
    NSDictionary *dic = (self.addressType == SetAddressTypeHouse) ? self.tempDataDic[@"owner"][@"homeLngLat"] : self.tempDataDic[@"owner"][@"schoolLngLat"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
    self.searchCoordinate = coordinate;
    [self addFenceWithCoordinate:coordinate];
    
    NSString *addressStr = NO_NULL((self.addressType == SetAddressTypeHouse) ? self.tempDataDic[@"owner"][@"homePoi"] : self.tempDataDic[@"owner"][@"schoolPoi"])
    self.addressLabel.text = addressStr;
}

#pragma mark 添加围栏
- (void)addFenceWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //coordinate = [self makeGPSCoordinate:coordinate];
    [self setLocationCoordinate:coordinate];
    [self setFenceCoordinate:coordinate];
    //[self getReverseGeocodeWithLocation:coordinate];
    
}

#pragma mark 添加地图标注
- (void)setLocationCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    [self.mapView addAnnotation:point];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}

#pragma mark 添加围栏
- (void)setFenceCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView removeOverlays:self.mapView.overlays];
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coordinate radius:self.fenceValue];
    [self.mapView addOverlay:circle];
}

#pragma mark BMKMapViewDelegate

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
        newAnnotationView.image = [UIImage imageNamed:(self.addressType == SetAddressTypeHouse) ? @"location_home" : @"location_school"];
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithCircle:overlay];
        /// 填充颜色
        circleView.fillColor = RGBA(0.0, 255.0, .0, .2);
        /// 画笔颜色
        circleView.strokeColor = RGB(255.0, 0.0, 0.0);
        /// 画笔宽度，默认为0
        circleView.lineWidth = 1.0;
        return circleView;
    }
    return nil;
}

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    //[self addFenceWithCoordinate:coordinate]; 
    self.searchCoordinate = coordinate;
    [self setLocationCoordinate:coordinate];
    [self setFenceCoordinate:coordinate];
    [self getReverseGeocodeWithLocation:coordinate];
}


#pragma mark 编译地址
- (void)getReverseGeocodeWithLocation:(CLLocationCoordinate2D)locaotion
{
    NSLog(@"locaotion===%f===%f",locaotion.latitude,locaotion.longitude);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        if (self.geocodesearch)
        {
            self.geocodesearch.delegate = nil;
            self.geocodesearch = nil;
        }
        self.geocodesearch = [[BMKGeoCodeSearch alloc] init];
        self.geocodesearch.delegate = self;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = locaotion;
        BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    });
}


#pragma mark 坐标转换地址Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result====%@",[[result  addressDetail] description]);
    self.addressLabel.text = [result  address];
    NSMutableDictionary *ownerDic = [NSMutableDictionary dictionaryWithDictionary:self.tempDataDic[@"owner"]];
    [ownerDic setValue:result.address forKey:(self.addressType == SetAddressTypeHouse) ? @"homePoi" : @"schoolPoi"];
    NSMutableDictionary *positionDic = [NSMutableDictionary dictionaryWithDictionary:(self.addressType == SetAddressTypeHouse) ? ownerDic[@"homeLngLat"] : ownerDic[@"schoolLngLat"]];
    [positionDic setValue:[NSString stringWithFormat:@"%f",result.location.latitude] forKey:@"lat"];
    [positionDic setValue:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"lng"];
    [ownerDic setValue:positionDic forKey:(self.addressType == SetAddressTypeHouse) ? @"homeLngLat" : @"schoolLngLat"];
    [self.tempDataDic setValue:ownerDic forKey:@"owner"];
    
}


#pragma mark 保存
- (void)saveButtonPressed:(UIButton *)sender
{
    [self setGuardInfo];
}

#pragma mark 设置守护
- (void)setGuardInfo
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING];
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
