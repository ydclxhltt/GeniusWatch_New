//
//  OutSideAddressViewController.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/10/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicViewController.h"
#import "BMapKit.h"

@interface OutSideAddressViewController : BasicViewController

@property (nonatomic, assign) CLLocationCoordinate2D searchCoordinate;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, assign) SetAddressType addressType;

@end
