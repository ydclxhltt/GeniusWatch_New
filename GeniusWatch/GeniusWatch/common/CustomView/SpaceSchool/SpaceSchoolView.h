//
//  SpaceSchoolView.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpaceSchoolView : UIView

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isHighlighted;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array;

@end
