//
//  LeftRightLableCell.h
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftRightLableCell : UITableViewCell

//设置数据
- (void)setDataWithLeftText:(NSString *)left rightText:(NSString *)right;

//设置颜色
- (void)setLeftColor:(UIColor *)l_color rightColor:(UIColor *)r_color;

@end
