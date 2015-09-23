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
        self.currentIndex = 0;
        //,@"custom_female"
        self.imagesArray = @[@"father",@"mother",@"grandfather",@"grandmother",@"grandfather1",@"grandmother2",@"custom_man"];
        //,@"自定义头像(女)" @"自定义头像(男)"
        self.titlesArray = @[@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"自定义头像"];
    }
    return self;
}

@end
