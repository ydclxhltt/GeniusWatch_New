//
//  PointView.m
//  GeniusWatch
//
//  Created by clei on 15/9/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "PointView.h"

#define SPACE_X         5.0
#define SPACE_Y         5.0
#define LABEL_HEIGHT    20.0

@interface PointView()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation PointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    float iconHW = self.frame.size.height - 2 * SPACE_Y - LABEL_HEIGHT;
    _iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(SPACE_X, SPACE_Y, iconHW, iconHW) placeholderImage:nil borderColor:nil imageUrl:nil];
    _iconImageView.backgroundColor = [UIColor grayColor];
    [self addSubview:_iconImageView];
    
    //_infoLabel = [CreateViewTool createLabelWithFrame:<#(CGRect)#> textString:@"14:00" textColor:<#(UIColor *)#> textFont:<#(UIFont *)#>];
    
}



@end
