//
//  BabyIocnView.m
//  GeniusWatch
//
//  Created by clei on 15/9/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BabyIocnView.h"



@interface BabyIocnView()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *infoLable;

@end


@implementation BabyIocnView

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


#pragma mark 初始化UI
- (void)initUI
{
    float width = self.frame.size.height - INFO_LABLE_HEIGHT;
    float height = self.frame.size.height - INFO_LABLE_HEIGHT;
    float x = (self.frame.size.width - width)/2;
    _iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(x, 0, width, height) placeholderImage:nil borderColor:[UIColor whiteColor] imageUrl:nil];
    [self addSubview:_iconImageView];
    
    float y = _iconImageView.frame.size.height + _iconImageView.frame.origin.y;
    _infoLable = [CreateViewTool  createLabelWithFrame:CGRectMake(0, y, self.frame.size.width, INFO_LABLE_HEIGHT) textString:@"" textColor:TIP_COLOR textFont:TIP_FONT];
    _infoLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_infoLable];
}


#pragma mark 设置数据
- (void)setImageWithUrl:(NSString *)url defaultImage:(NSString *)imageName  infoLableText:(NSString *)text
{
    url = url ? url : @"";
    [self.iconImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName]];
    self.infoLable.text = text;
}

#pragma mark 设置label
- (void)setInfoLableTextColor:(UIColor *)color textFont:(UIFont *)font
{
    self.infoLable.textColor = color;
    self.infoLable.font = font;
}

#pragma mark 设置icon
- (void)setIconImage:(UIImage *)image
{
    self.iconImageView.image = image;
}

@end
