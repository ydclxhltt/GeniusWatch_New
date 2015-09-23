//
//  LinkManListCell.h
//  GeniusWatch
//
//  Created by clei on 15/9/16.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkManListCell : UITableViewCell

- (void)setContactDataWithDictionary:(NSDictionary *)dataDic;
- (void)setContactDataWithIconImage:(UIImage *)image name:(NSString *)name mobile:(NSString *)mobile shortNumber:(NSString *)shortNumber;

@end
