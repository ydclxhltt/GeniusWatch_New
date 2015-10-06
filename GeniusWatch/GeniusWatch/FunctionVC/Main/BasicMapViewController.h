//
//  BasicMapViewController.h
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//


#import "BasicViewController.h"
#import "BMapKit.h"

@interface BasicMapViewController : BasicViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) UIButton *locaitonButton;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

//添加地图
- (void)addMapView;
//- (void)addMapViewWithDelegate:(id)delegate;

//添加模式切换按钮
- (void)addTypeButton;

//添加更新按钮
- (void)addLocationButton;

//添加缩放按钮
- (void)addZoomButton;

- (CLLocationCoordinate2D)makeGPSCoordinate:(CLLocationCoordinate2D)coordinate;
@end
