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
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIScrollView *scrollView;

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
    self = [super initWithFrame:frame];
    if (self)
    {
        self.line_x = POINT_WIDTH/2 + SPACE_X - LINE_WIDTH/2;
        self.dataArray = array;
        self.pointArray = [NSMutableArray array];
        [self initUI];
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
            [_scrollView addSubview:pointView];
            UIImage *image = [UIImage imageNamed:@"chatfrom_bg_normal"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
            
             float x  = pointView.frame.size.width + pointView.frame.origin.x + ADD_X;
            imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x , y, _scrollView.frame.size.width - pointView.frame.size.width - 2 * SPACE_X - ADD_X, ITEM_HEIGHT) placeholderImage:image];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [_scrollView addSubview:imageView];
            
            if (i == 0)
            {
                [self.pointArray addObject:@(pointView.frame.origin.y + pointView.frame.size.height)];
            }
            else
            {
                [self.pointArray addObject:@(point_y)];
                if (i != [self.dataArray count] - 1)
                {
                    [self.pointArray addObject:@(pointView.frame.origin.y + pointView.frame.size.height)];
                }
                
                int index = (i - 1) * 2 ;
                {
                    float lineHeight = [self.pointArray[index + 1] floatValue] - [self.pointArray[index] floatValue];
                    lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(self.line_x, [self.pointArray[index] floatValue], LINE_WIDTH, lineHeight) placeholderImage:nil];
                    lineImageView.backgroundColor = [UIColor lightGrayColor];
                    [_scrollView addSubview:lineImageView];
                }
            }
            
        }
    }
    NSLog(@"=====%@",self.pointArray);
}


@end
