//
//  AddLinkManViewController.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/20.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicViewController.h"

typedef enum : NSUInteger
{
    PushForAdd,
    PushForChange,
} PushFor;

@interface AddLinkManViewController : BasicViewController

@property (nonatomic, assign) PushFor pushFor;
@property (nonatomic, strong) NSDictionary *dataDic;

@end
