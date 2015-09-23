//
//  LinkManListCell.m
//  GeniusWatch
//
//  Created by clei on 15/9/16.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//
#define SPACE_Y             10.0
#define SPACE_X             10.0
#define NAME_LABLE_WIDTH    60.0
#define LABLE_WIDTH         150.0
#define LABEL_HEIGHT        20.0
#define CELL_HEIGHT         75.0
#define ICON_IMAGEVIE_WH    35.0
#define ADD_X               10.0
#define ADD_Y               5.0


#import "LinkManListCell.h"

@interface LinkManListCell()

@property (nonatomic, strong) UIImageView  *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *shortLabel;

@end

@implementation LinkManListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(SPACE_X, SPACE_Y, ICON_IMAGEVIE_WH, ICON_IMAGEVIE_WH) placeholderImage:nil borderColor:APP_MAIN_COLOR imageUrl:@""];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, _iconImageView.frame.origin.y + _iconImageView.frame.size.height, NAME_LABLE_WIDTH, LABEL_HEIGHT) textString:@"" textColor:[UIColor grayColor] textFont:FONT(12.0)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    _mobileLabel = [CreateViewTool createLabelWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + ADD_X, SPACE_Y + ADD_Y, LABLE_WIDTH, LABEL_HEIGHT) textString:@"" textColor:[UIColor grayColor] textFont:FONT(14.0)];
    [self.contentView addSubview:_mobileLabel];
    
    _shortLabel = [CreateViewTool createLabelWithFrame:CGRectMake(_mobileLabel.frame.origin.x, _mobileLabel.frame.origin.y + _mobileLabel.frame.size.height + ADD_Y, LABLE_WIDTH, LABEL_HEIGHT) textString:@"" textColor:[UIColor grayColor] textFont:FONT(15.0)];
    [self.contentView addSubview:_shortLabel];
}

#pragma mark 设置数据
- (void)setContactDataWithDictionary:(NSDictionary *)dataDic
{
    if (!dataDic)
    {
        return;
    }
    NSString *name = dataDic[@"nickName"];
    name = name ? name : @"";
    NSString *mobile = dataDic[@"mobileNo"];
    mobile = mobile ? mobile : @"";
    NSString *shortNumber = dataDic[@"shortPhoneNo"];
    shortNumber = shortNumber ? shortNumber : @"";
    shortNumber = (shortNumber.length == 0) ? @"没有亲情号/短号" : [@"短号/亲情号:" stringByAppendingString:shortNumber];
        ;
    NSString *imageName = @"custom_man";
    int index = (int)[[GeniusWatchApplication shareApplication].titlesArray indexOfObject:name];
    imageName = (index > [[GeniusWatchApplication shareApplication].titlesArray count]) ? imageName : [GeniusWatchApplication shareApplication].imagesArray[index];
    UIImage *image = [UIImage imageNamed:imageName];
    [self setContactDataWithIconImage:image name:name mobile:mobile shortNumber:shortNumber];
}

- (void)setContactDataWithIconImage:(UIImage *)image name:(NSString *)name mobile:(NSString *)mobile shortNumber:(NSString *)shortNumber
{
    self.iconImageView.image = image;
    self.nameLabel.text = name;
    self.mobileLabel.text = mobile;
    self.shortLabel.text = shortNumber;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
