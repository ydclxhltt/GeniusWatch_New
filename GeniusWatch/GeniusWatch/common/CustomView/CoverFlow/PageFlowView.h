//
//  PageFlowView.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/22.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FlowViewOrientationHorizontal = 0,
    FlowViewOrientationVertical
}FlowViewOrientation;

typedef enum {
	PageDirectionPrevious = 0,
	PageDirectionDown
} PageDirectionE;

@protocol PageFlowViewDataSource;
@protocol PageFlowViewDelegate;

@interface PageFlowView : UIView<UIScrollViewDelegate>{
    FlowViewOrientation  _orientation;      
    UIScrollView        *_scrollView;
    UIImageView         *_defaultImageView;   //default，when no data，display default image
    
    BOOL                _needsReload;
    
    CGSize              _pageSize;             //size of page
    NSInteger           _pageCount;            //total page count 
    NSInteger           _currentPageIndex;
    
    NSRange              _visibleRange;
    
    NSMutableArray      *_reusableCells;     //UnseedCell
    NSMutableArray      *_inUseCells;        //using Cell
    
    CGFloat _minimumPageAlpha;          //default is 1.0
    CGFloat _minimumPageScale;          //default is 1.0
    
}

@property (nonatomic, assign) id <PageFlowViewDataSource> dataSource;
@property (nonatomic, assign) id <PageFlowViewDelegate>   delegate;
@property (nonatomic, retain) UIImageView         *defaultImageView;
@property (nonatomic, assign) FlowViewOrientation orientation;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
@property (nonatomic, assign) CGFloat minimumPageAlpha;
@property (nonatomic, assign) CGFloat minimumPageScale;

- (void)reloadData;
- (UIView *)dequeueReusableCell;
- (UIView *)cellForItemAtCurrentIndex:(NSInteger)currentIndex;

- (void)scrollToNextPage;

@end

@protocol  PageFlowViewDelegate<NSObject>
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index;

@optional
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PageFlowView *)flowView;
- (void)didSelectItemAtIndex:(NSInteger)index inFlowView:(PageFlowView *)flowView;

@end


@protocol PageFlowViewDataSource <NSObject>

// Return the number of views.
- (NSInteger)numberOfPagesInFlowView:(PageFlowView *)flowView;
- (CGSize)sizeForPageInFlowView:(PageFlowView *)flowView;

// Reusable cells
- (UIView *)flowView:(PageFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end

