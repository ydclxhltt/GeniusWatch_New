//
//  AddressViewController.h
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicMapViewController.h"

@interface AddressViewController : BasicMapViewController

@property (nonatomic, assign) SetAddressType  addressType;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end
