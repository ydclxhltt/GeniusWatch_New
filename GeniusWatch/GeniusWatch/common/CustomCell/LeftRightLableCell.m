//
//  LeftRightLableCell.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LeftRightLableCell.h"

#define SPACE_X          10.0
#define ADD_SPACE_X      20.0 * CURRENT_SCALE
#define ARROW_WIDTH      30.0
#define SELF_HEIGHT      44.0
#define TIME_LABEL_WIDTH 120.0  * CURRENT_SCALE
#define LABEL_HEIGHT     20.0


@interface LeftRightLableCell()
{
    UILabel *leftLabel;
    UILabel *rightLabel;
}
@end

@implementation LeftRightLableCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addLabels];
}

- (void)addLabels
{
    rightLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - ARROW_WIDTH - TIME_LABEL_WIDTH, (SELF_HEIGHT - LABEL_HEIGHT)/2, TIME_LABEL_WIDTH, LABEL_HEIGHT) textString:@"" textColor:RGB(138.0, 138.0, 138.0) textFont:FONT(14.0)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightLabel];
    
    leftLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, (SELF_HEIGHT - LABEL_HEIGHT)/2, rightLabel.frame.origin.x - ADD_SPACE_X, LABEL_HEIGHT) textString:@"" textColor:[UIColor blackColor] textFont:FONT(16.0)];
    [self.contentView addSubview:leftLabel];
}

#pragma mark 设置数据
- (void)setDataWithLeftText:(NSString *)left rightText:(NSString *)right
{
    leftLabel.text = (left) ? left : @"";
    rightLabel.text = (right) ? right : @"";
    
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        rightLabel.frame = CGRectMake(SCREEN_WIDTH - ARROW_WIDTH - TIME_LABEL_WIDTH, (SELF_HEIGHT - LABEL_HEIGHT)/2, TIME_LABEL_WIDTH, LABEL_HEIGHT);
    }
    else
    {
        rightLabel.frame = CGRectMake(SCREEN_WIDTH - 2 * SPACE_X - TIME_LABEL_WIDTH, (SELF_HEIGHT - LABEL_HEIGHT)/2, TIME_LABEL_WIDTH, LABEL_HEIGHT);
    }
}

- (void)setLeftColor:(UIColor *)l_color rightColor:(UIColor *)r_color
{
    if (l_color)
        leftLabel.textColor = l_color;
    if (r_color)
        rightLabel.textColor = r_color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
