//
//  BasicMapViewController.h
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

typedef enum : NSUInteger {
    SetAddressTypeSchool,
    SetAddressTypeHouse,
} SetAddressType;

#import "BasicViewController.h"
#import "BMapKit.h"

@interface BasicMapViewController : BasicViewController<BMKMapViewDelegate>

@property (nonatomic, retain) BMKMapView *mapView;

//添加地图
- (void)addMapView;

//添加模式切换按钮
- (void)addTypeButton;

//添加更新按钮
- (void)addLocationButton;

//添加缩放按钮
- (void)addZoomButton;


@end
