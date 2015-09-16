//
//  AddPicView.h
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PIC_SPACE_Y       15.0 * CURRENT_SCALE
#define PIC_SPACE_X       10.0 * CURRENT_SCALE

@protocol  AddPicViewDelegate;

@interface AddPicView : UIView


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id<AddPicViewDelegate> delegate;
@property (nonatomic, strong) UIImage *addImage;

- (void)setDataWithImageArray:(NSArray *)array;
- (void)selectImages;
- (instancetype)initWithFrame:(CGRect)frame maxPicCount:(int)maxCount superViewController:(UIViewController *)viewController;

@end

@protocol AddPicViewDelegate <NSObject>

@optional

- (void)addPicButtonClicked:(AddPicView *)addPicView;
- (void)addPicView:(AddPicView *)addPicView clickedImageViewIndex:(int)index;

@end