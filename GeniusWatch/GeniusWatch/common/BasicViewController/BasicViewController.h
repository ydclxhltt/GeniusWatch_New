//
//  BasicViewController.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/22.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTFIELD_HEIGHT    35.0
#define BUTTON_HEIGHT       40.0
#define BUTTON_RADIUS       5.0
#define TEXTFIELD_RADIUS    5.0
#define BUTTON_FONT         FONT(16.0)
#define TEXTFIELD_FONT      FONT(16.0)
#define TEXTFIELD_COLOR     RGB(86.0,86.0,86.0)
#define BUTTON_N_COLOR      APP_MAIN_COLOR
#define BUTTON_H_COLOR      [UIColor grayColor]
#define BUTTON_TITLE_COLOR  [UIColor whiteColor]
//#define TEXTFIELD_COLOR     APP_MAIN_COLOR

typedef enum : NSUInteger
{
    LeftItem,
    RightItem,
} NavItemType;

typedef enum : NSUInteger {
    PushTypeRegister = 0,
    PushTypeNewPassword = 1,
} PushType;

typedef enum : NSUInteger {
    ShowTypePush,
    ShowTypePresent,
} ShowType;

@interface BasicViewController : UIViewController
{
    float start_y;
}

@property (nonatomic, strong) UITableView *table;

/*
 *  设置导航条Item
 *
 *  @param title     按钮title
 *  @param type      NavItemType 设置左或右item的标识
 *  @param selName   item按钮响应方法名
 */
- (void)setNavBarItemWithTitle:(NSString *)title navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item
 *
 *  @param imageName 图片名字
 *  @param type      NavItemType 设置左或右item的标识
 *  @param selName   item按钮响应方法名
 */
- (void)setNavBarItemWithImageName:(NSString *)imageName navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item back按钮
 */
- (void)addBackItem;

/*
 *  添加表视图，如：tableView
 *
 *  @param frame     tableView的frame
 *  @param type      UITableViewStyle
 *  @param delegate  tableView的委托对象
 *
 */
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate;

@end
