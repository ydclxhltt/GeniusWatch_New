//
//  LocationViewController.h
//  GeniusWatch
//
//  Created by clei on 15/9/6.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicMapViewController.h"

@interface LocationViewController : BasicMapViewController

@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic, strong) NSString *lastAddress;
@property (nonatomic, strong) NSDictionary *dataDic;

@end
