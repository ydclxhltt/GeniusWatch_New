//
//  GeniusWatchApplication.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "GeniusWatchApplication.h"

@implementation GeniusWatchApplication


+ (instancetype)shareApplication
{
   static GeniusWatchApplication *geniusWatchApplication = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            geniusWatchApplication = [[self alloc] init];
        });
    return geniusWatchApplication;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.isLaunchLogin = YES;
        self.currentDeviceIndex = 0;
    }
    return self;
}

@end
