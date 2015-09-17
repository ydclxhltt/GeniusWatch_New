//
//  PointView.m
//  GeniusWatch
//
//  Created by clei on 15/9/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "PointView.h"

@interface PointView()

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
    
    float iconHW = self.frame.size.height - 2 * POINT_SPACE_Y - POINT_LABEL_HEIGHT;
    _iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake((self.frame.size.width - iconHW)/2, POINT_SPACE_Y, iconHW, iconHW) placeholderImage:nil borderColor:nil imageUrl:nil];
    _iconImageView.backgroundColor = [UIColor grayColor];
    _iconImageView.highlightedAnimationImages = nil;
    [self addSubview:_iconImageView];
    
    float y = _iconImageView.frame.size.height + _iconImageView.frame.origin.y;
    _infoLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, y, self.frame.size.width, POINT_LABEL_HEIGHT) textString:@"14:00" textColor:TIP_COLOR textFont:FONT(14.0)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_infoLabel];
    
}

- (void)setDataWithInfo:(NSString *)infoStr isSelected:(BOOL)selected isHighlighted:(BOOL)highlighted
{
    infoStr = (infoStr) ? infoStr : @"";
    self.infoLabel.text = infoStr;
    CGRect frame = self.iconImageView.frame;
    if (infoStr.length == 0)
    {
        float y = (self.frame.size.height - frame.size.height)/2;
        self.iconImageView.frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    }
    else
    {
        self.iconImageView.frame = CGRectMake(frame.origin.x, POINT_SPACE_Y, frame.size.width, frame.size.height);
    }
    
    self.iconImageView.backgroundColor = (selected) ? APP_MAIN_COLOR : [UIColor grayColor];
    self.iconImageView.highlighted = highlighted;
}


@end
