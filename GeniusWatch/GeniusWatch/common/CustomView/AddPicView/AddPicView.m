//
//  AddPicView.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddPicView.h"
#import "UpLoadPhotoTool.h"

#define PIC_WH          65.0
#define PIC_ADD_X       10.0
#define ADD_IMAGE_NAME  @"Detail_add_pic.png"

@interface AddPicView()<UploadPhotoDelegate>
{
    UIScrollView *picScrollView;
    UIButton *addImageButton;
}

@end

@implementation AddPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}


#pragma mark 初始化UI
- (void)initUI
{
    if (!picScrollView)
    {
        picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        picScrollView.bounces = NO;
        picScrollView.showsHorizontalScrollIndicator = NO;
        picScrollView.showsVerticalScrollIndicator = NO;
        picScrollView.pagingEnabled = YES;
        [self addSubview:picScrollView];
        
        addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //addImageButton.frame = CGRectMake(0, 0, PIC_WH, PIC_WH);
        addImageButton.frame = CGRectMake(self.frame.size.width - PIC_WH, 0, PIC_WH, PIC_WH);
        [addImageButton setImage:[UIImage imageNamed:ADD_IMAGE_NAME] forState:UIControlStateNormal];
        [addImageButton addTarget:self action:@selector(addPicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [picScrollView addSubview:addImageButton];
    }
}

#pragma mark 设置数据
- (void)setDataWithImageArray:(NSArray *)array upLoadType:(int)type
{
    if (!array || [array count] == 0)
    {
        return;
    }
    if (!self.dataArray)
    {
        self.dataArray = array;
    }
    else
    {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.dataArray];
        [newArray addObjectsFromArray:array];
        self.dataArray = newArray;
    }
    if (self.dataArray)
    {
        //addImageButton.frame = CGRectMake(self.dataArray.count * (PIC_WH + PIC_ADD_X), 0 , PIC_WH, PIC_WH);
        NSLog(@"131231===%@====%@",NSStringFromCGRect(addImageButton.frame),NSStringFromCGRect(self.frame));
        if ([self.dataArray count] >= self.maxPicCount)
        {
            [addImageButton setAlpha:.0];
        }
    }
    
    if (self.dataArray && [self.dataArray count] > 0)
    {
        NSMutableArray *uploadArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.dataArray count]; i++)
        {
            if ([self.dataArray count] > self.maxPicCount)
            {
                return;
            }
            UIImageView *imageView = (UIImageView *)[picScrollView viewWithTag:i + 1];
            if (!imageView)
            {
                imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(i * (PIC_WH + PIC_ADD_X), 0, PIC_WH, PIC_WH) placeholderImage:nil];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.tag = i + 1;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
                [imageView addGestureRecognizer:tapGesture];
                [picScrollView addSubview:imageView];
            }
            if (imageView.image != self.dataArray[i])
            {
                [uploadArray addObject:self.dataArray[i]];
            }
            imageView.image = self.dataArray[i];
        }
        //上传
        NSString *url = (type != 0) ? @"" : @"";
        UpLoadPhotoTool *upLoadTool = [[UpLoadPhotoTool alloc] initWithPhotoArray:uploadArray upLoadUrl:url upLoadType:type];
        upLoadTool.delegate = self;
    }
}


#pragma mark UpLoadPhotoDelegate
- (void)uploadPhotoSucessed:(UpLoadPhotoTool *)upLoadPhotoTool
{
    //[SVProgressHUD showSuccessWithStatus:@"上传成功"];
    //UIImageView *imageView = (UIImageView *)[picScrollView viewWithTag:upLoadPhotoTool.currentIndex + 1];
    //imageView.alpha = 1.0;
    NSDictionary *responseDic = (NSDictionary *)upLoadPhotoTool.responseDic;
    NSDictionary *picDic = responseDic[@"model"][@"photoList"][0];
    if (!self.picListArray)
    {
        self.picListArray = [NSMutableArray arrayWithCapacity:1];
    }
    [self.picListArray addObject:@([picDic[@"id"] intValue])];
}
- (void)uploadPhotoFailed:(UpLoadPhotoTool *)upLoadPhotoTool
{
    //[SVProgressHUD showErrorWithStatus:@"上传失败"];
    //UIImageView *imageView = (UIImageView *)[picScrollView viewWithTag:upLoadPhotoTool.currentIndex + 1];
    //imageView.alpha = 0.5;
}

- (void)uploadPhoto:(UpLoadPhotoTool *)upLoadPhotoTool isUploadedPhotoProcess:(float)process
{
    NSLog(@"=====%f",process * 100);
    //UIImageView *imageView = (UIImageView *)[picScrollView viewWithTag:upLoadPhotoTool.currentIndex + 1];
    //imageView.alpha = 0.5 + 0.5 * process;
    //[SVProgressHUD showWithStatus:[NSString stringWithFormat:@"已上传%.1f％",process * 100]];
}



#pragma mark 添加图片
- (void)addPicButtonPressed:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addPicButtonClicked:)])
    {
        [self.delegate addPicButtonClicked:self];
    }
}


#pragma mark 点击图片
- (void)imageViewPressed:(UITapGestureRecognizer *)tapGesture
{
    
}


@end
