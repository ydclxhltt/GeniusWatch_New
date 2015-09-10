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

+ (instancetype)shareApplication;

@end
