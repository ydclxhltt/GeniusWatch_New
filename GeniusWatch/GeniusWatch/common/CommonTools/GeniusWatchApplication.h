//
//  GeniusWatchApplication.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeniusWatchApplication : NSObject

@property (nonatomic, assign) BOOL isLaunchLogin;
@property (nonatomic, strong) NSMutableArray *deviceList;
@property (nonatomic, assign) int currentDeviceIndex;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDictionary *currentDeviceDic;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titlesArray;

+ (instancetype)shareApplication;

@end
