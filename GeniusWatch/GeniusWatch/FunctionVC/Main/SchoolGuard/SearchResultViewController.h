//
//  SearchResultViewController.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/10/6.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicViewController.h"
#import "BMapKit.h"

@interface SearchResultViewController : BasicViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, assign) SetAddressType addressType;

@end
