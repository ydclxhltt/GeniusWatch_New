//
//  SetSchoolInfoViewController.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/18.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicViewController.h"

@interface SetSchoolInfoViewController : BasicViewController

@property (nonatomic, assign) BOOL isSetClassTime;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

- (void)addTableView;
- (void)addButtons;

@end
