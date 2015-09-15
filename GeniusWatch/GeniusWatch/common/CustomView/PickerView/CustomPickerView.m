//
//  CustomPickerView.m
//  GeniusWatch
//
//  Created by clei on 15/9/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "CustomPickerView.h"


@implementation CustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)type customSureBlock:(void (^)(UIPickerView *, int))customSure cancelBlock:(void (^)())customCancel pickerData:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}


#pragma mark 初始化UI
- (void)initUI
{
    //CLPickerView *
}


@end
