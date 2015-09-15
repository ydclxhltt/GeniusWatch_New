//
//  BabyIocnView.h
//  GeniusWatch
//
//  Created by clei on 15/9/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INFO_LABLE_HEIGHT   25.0

@interface BabyIocnView : UIView

- (void)setImageWithUrl:(NSString *)url defaultImage:(NSString *)imageName  infoLableText:(NSString *)text;

- (void)setInfoLableTextColor:(UIColor *)color textFont:(UIFont *)font;

@end
