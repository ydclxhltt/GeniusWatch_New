//
//  AddPicView.h
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AddPicViewDelegate;

@interface AddPicView : UIView
@property (nonatomic, assign) int maxPicCount;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) id<AddPicViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *picListArray;

- (void)setDataWithImageArray:(NSArray *)array upLoadType:(int)type;
@end

@protocol AddPicViewDelegate <NSObject>

@optional

- (void)addPicButtonClicked:(AddPicView *)addPicView;
- (void)addPicView:(AddPicView *)addPicView clickedImageViewIndex:(int)index;

@end