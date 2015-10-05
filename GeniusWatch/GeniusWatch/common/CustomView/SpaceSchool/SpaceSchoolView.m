//
//  SpaceSchoolView.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SpaceSchoolView.h"
#import "PointView.h"

#define  SPACE_X       15.0 * CURRENT_SCALE
#define  SPACE_Y       20.0 * CURRENT_SCALE
#define  ADD_Y         30.0 * CURRENT_SCALE
#define  ADD_X         10.0 * CURRENT_SCALE
#define  ITEM_HEIGHT   60.0 * CURRENT_SCALE
#define  POINT_WIDTH   40.0
#define  POINT_HEIGHT  40.0
#define  LINE_WIDTH    1.0

@interface SpaceSchoolView()

@property (nonatomic, assign) float line_x;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *tipArray;

@end

@implementation SpaceSchoolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.dataArray = array;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.line_x = POINT_WIDTH/2 + SPACE_X - LINE_WIDTH/2;
        self.pointArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark 初始化UI
- (void)initUI
{
    [self addScrollView];
}

- (void)addScrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    [self addTipViews];
}

- (void)addTipViews
{
    if (!self.dataArray || [self.dataArray count] == 0)
    {
        return;
    }
  
    for (int i = 0; i < [self.dataArray count] ; i++)
    {
        PointView *pointView = (PointView *)[_scrollView viewWithTag:i + 1];
        UIImageView *imageView = (UIImageView *)[_scrollView viewWithTag:i + 100];
        UILabel *label = (UILabel *)[_scrollView viewWithTag:i + 1000];
        UIImageView *lineImageView = (UIImageView *)[_scrollView viewWithTag:i + 10000];
        if (!pointView)
        {
            float y = SPACE_Y + (ITEM_HEIGHT + ADD_Y) * i;
            float imageHeight = POINT_HEIGHT - 2 * POINT_SPACE_Y - POINT_LABEL_HEIGHT;
            float point_y = y + ITEM_HEIGHT/2 - (imageHeight/2 + POINT_SPACE_Y);
            pointView = [[PointView alloc] initWithFrame:CGRectMake(SPACE_X, point_y, POINT_WIDTH, POINT_HEIGHT)];
            pointView.tag = 1 + i;
            [_scrollView addSubview:pointView];
            UIImage *image = [UIImage imageNamed:@"chatfrom_bg_normal"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
            
             float x  = pointView.frame.size.width + pointView.frame.origin.x + ADD_X;
            imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x , y, _scrollView.frame.size.width - pointView.frame.size.width - 2 * SPACE_X - ADD_X, ITEM_HEIGHT) placeholderImage:image];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.tag = 100 + i;
            [_scrollView addSubview:imageView];
            
            float space_x = 22.0;
            float space_y = 5.0;
            label = [CreateViewTool createLabelWithFrame:CGRectMake(imageView.frame.origin.x + space_x, imageView.frame.origin.y + space_y, imageView.frame.size.width - 2 * space_x, imageView.frame.size.height - 2 * space_y) textString:@"" textColor:[UIColor lightGrayColor] textFont:FONT(16.0)];
            label.tag = 1000 + i;
            label.numberOfLines = 2;
            [_scrollView addSubview:label];
            
            //画线
            NSString *string = self.dataArray[i];
            float add_y = (string.length == 0) ? - POINT_LABEL_HEIGHT : 0.0;
            if (i == 0)
            {
                [self.pointArray addObject:@(pointView.frame.origin.y + pointView.frame.size.height + add_y)];
            }
            else
            {
                [self.pointArray addObject:@(point_y)];
                if (i != [self.dataArray count] - 1)
                {
                    [self.pointArray addObject:@(pointView.frame.origin.y + pointView.frame.size.height + add_y)];
                }
                
                int index = (i - 1) * 2 ;
                if (!lineImageView)
                {
                    float lineHeight = [self.pointArray[index + 1] floatValue] - [self.pointArray[index] floatValue];
                    lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(self.line_x, [self.pointArray[index] floatValue], LINE_WIDTH, lineHeight) placeholderImage:nil];
                    lineImageView.backgroundColor = [UIColor lightGrayColor];
                    lineImageView.tag = 10000 + i;
                    [_scrollView addSubview:lineImageView];
                }
            }
        }
        //改变pointView颜色
        [pointView setDataWithInfo:self.dataArray[i] isSelected:YES isHighlighted:NO];
        NSLog(@"self.tipArray==%@",self.tipArray);
        label.attributedText = self.tipArray[i];
    }

}


- (void)setLateTime:(NSString *)lateTime
{
    _lateTime = lateTime;
    NSString *str1 = @"放学路上逗留提醒\n路上逗留超过15分钟提醒家长";
    NSString *str2 = [@"到家提醒,晚到家提醒\n最晚到家时间:" stringByAppendingString:lateTime];
    NSMutableAttributedString *string1= [[NSMutableAttributedString alloc] initWithString:@"到学校提醒,迟到提醒"];
    NSMutableAttributedString *string2= [[NSMutableAttributedString alloc] initWithString:@"离校提醒"];
    NSMutableAttributedString *string3= [[NSMutableAttributedString alloc] initWithString:str1];
    NSMutableAttributedString *string4= [[NSMutableAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:FONT(14.0)}];
    [CommonTool makeString:str1 toAttributeString:string3 withString:@"路上逗留超过15分钟提醒家长" withTextColor:[UIColor lightGrayColor] withTextFont:FONT(14.0)];
    [CommonTool makeString:str2 toAttributeString:string4 withString:@"到家提醒,晚到家提醒" withTextColor:[UIColor lightGrayColor] withTextFont:FONT(16.0)];
    self.tipArray = @[string1,string2,string3,string4];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self initUI];
}


@end
