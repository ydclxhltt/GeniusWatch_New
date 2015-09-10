//
//  MainSideViewController.h
//
//
//  Created by clei on 14-5-10.
//  Copyright (c) 2014年 clei. All rights reserved.
//

/*!
 *	@class	侧边栏控制器,5.0以上系统使用
 */
#import <UIKit/UIKit.h>

typedef void(^RootViewMoveBlock)(UIView *rootView,CGRect orginFrame,CGFloat xoffset);

@interface MainSideViewController : UIViewController
{
     UIButton *_coverButton;
}
@property (assign,nonatomic) BOOL needSwipeShowMenu;//是否开启手势滑动出菜单

@property (strong,nonatomic) UIViewController *rootViewController;
@property (strong,nonatomic) UIViewController *leftViewController NS_AVAILABLE_IOS(5_0);
@property (strong,nonatomic) UIViewController *rightViewController NS_AVAILABLE_IOS(5_0);

@property (assign,nonatomic) CGFloat leftViewShowWidth;//左侧栏的展示大小
@property (assign,nonatomic) CGFloat rightViewShowWidth;//右侧栏的展示大小

@property (assign,nonatomic) NSTimeInterval animationDuration;//动画时长
@property (assign,nonatomic) BOOL showBoundsShadow;//是否显示边框阴影

@property (weak,nonatomic) RootViewMoveBlock rootViewMoveBlock;//可在此block中重做动画效果

+ (MainSideViewController *)sharedSliderController;
- (void)setRootViewMoveBlock:(RootViewMoveBlock)rootViewMoveBlock;
- (void)showLeftViewController:(BOOL)animated;//展示左边栏
- (void)showRightViewController:(BOOL)animated;//展示右边栏
- (void)hideSideViewController:(BOOL)animated;//恢复正常位置
- (void)setNeedSwipeShowMenu:(BOOL)needSwipeShowMenu;
@end
