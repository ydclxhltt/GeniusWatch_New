//
//  CreateQrCodeTool.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateQrcodeTool : NSObject

+ (UIImage *)createQrcodeWithString:(NSString *)qrString  imageSize:(float)size redColor:(float)red  greenColor:(float)green blueColor:(float)blue;

@end
