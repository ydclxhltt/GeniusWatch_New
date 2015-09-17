//
//  PointView.h
//  GeniusWatch
//
//  Created by clei on 15/9/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINT_SPACE_Y         5.0
#define POINT_LABEL_HEIGHT    20.0

@interface PointView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;

- (void)setDataWithInfo:(NSString *)infoStr isSelected:(BOOL)selected isHighlighted:(BOOL)highlighted;

@end
