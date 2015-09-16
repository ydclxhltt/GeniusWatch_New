//
//  AddPicView.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddPicView.h"
#import "AssetPickerController.h"

#define ADD_IMAGE_NAME  @"Detail_add_pic.png"

@interface AddPicView()<UIActionSheetDelegate,AssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *picScrollView;
    UIButton *addImageButton;
    float picWH;
    int selectedImageViewIndex;
}
@property (nonatomic, assign) int maxPicCount;
@property (nonatomic, assign) UIViewController *superViewController;

@end

@implementation AddPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame maxPicCount:(int)maxCount superViewController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        selectedImageViewIndex = -1;
        self.superViewController = viewController;
        self.maxPicCount = maxCount;
        picWH = frame.size.height - 2 * PIC_SPACE_Y;
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
        addImageButton.frame = CGRectMake(PIC_SPACE_X, PIC_SPACE_Y, picWH, picWH);
        [addImageButton setImage:[UIImage imageNamed:ADD_IMAGE_NAME] forState:UIControlStateNormal];
        [addImageButton addTarget:self action:@selector(addPicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [picScrollView addSubview:addImageButton];
    }
}

#pragma mark 设置数据
- (void)setDataWithImageArray:(NSArray *)array
{
    if (!array || [array count] == 0)
    {
        return;
    }
    if (!self.dataArray)
    {
        self.dataArray = [NSMutableArray arrayWithArray:array];
    }
    else
    {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.dataArray];
        [newArray addObjectsFromArray:array];
        self.dataArray = newArray;
    }
    if (self.dataArray)
    {
        addImageButton.frame = CGRectMake(PIC_SPACE_X + self.dataArray.count * (picWH + PIC_SPACE_X), PIC_SPACE_Y , picWH, picWH);
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
                imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(PIC_SPACE_X + i * (picWH + PIC_SPACE_X), PIC_SPACE_Y, picWH, picWH) placeholderImage:nil];
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
            
            picScrollView.contentSize = CGSizeMake((picWH + PIC_SPACE_X) * (([self.dataArray count]< self.maxPicCount) ? [self.dataArray count] + 1 : self.maxPicCount), picScrollView.frame.size.height);
        }
    }
}

#pragma mark 修改图片
- (void)setImageDataWithIndex:(int)index imageData:(UIImage *)image
{
    [self.dataArray replaceObjectAtIndex:index withObject:image];
}



#pragma mark 添加图片
- (void)addPicButtonPressed:(UIButton *)sender
{
    //默认弹出选择照片
    if (!self.delegate)
    {
        [self selectImages];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(addPicButtonClicked:)])
        {
            [self.delegate addPicButtonClicked:self];
        }
    }
}


- (void)selectImages
{
    if (self.superViewController)
    {
        UIActionSheet *actionSheet;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择" ,nil];
            actionSheet.tag = 100;
            
        }
        else
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择" ,nil];
            actionSheet.tag = 200;
        }
        actionSheet.delegate = self;
        [actionSheet showInView:self.superViewController.view];
    }
}

#pragma mark 点击图片
- (void)imageViewPressed:(UITapGestureRecognizer *)tapGesture
{
    selectedImageViewIndex = (int)tapGesture.view.tag - 1;
    if (!self.delegate)
    {
        [self selectImages];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(addPicView:clickedImageViewIndex:)])
        {
            [self.delegate addPicView:self clickedImageViewIndex:(int)tapGesture.view.tag];
        }

    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)
    {
        if (buttonIndex == 0)
        {
            [self showImagePickerViewContrller];
        }
        else if (buttonIndex == 2)
        {
            [self showAssetPickerController];
        }
    }
    if (actionSheet.tag == 200)
    {
        if (buttonIndex == 0)
        {
            [self showAssetPickerController];
        }
    }
}

- (void)showAssetPickerController
{
    AssetPickerController *picker = [[AssetPickerController alloc] init];
    picker.navigationBar.tintColor = APP_MAIN_COLOR;
    int count = self.maxPicCount - (int)[self.dataArray count];
    picker.maximumNumberOfSelection = (count == 0) ? 1 : count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                              {
                                  if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
                                  {
                                      NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                                      return duration >= 5;
                                  }
                                  else
                                  {
                                      return YES;
                                  }
                              }];
    [self.superViewController presentViewController:picker animated:YES completion:^{}];
}


- (void)showImagePickerViewContrller
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = APP_MAIN_COLOR;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.superViewController presentViewController:picker animated:YES completion:Nil];
}


#pragma mark - AssetPickerController Delegate
-(void)assetPickerController:(AssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSMutableArray *array = [NSMutableArray array];
                       for (int i = 0; i < assets.count; i++)
                       {
                           ALAsset *asset=assets[i];
                           UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                           [array addObject:tempImg];
                       }
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (selectedImageViewIndex != -1)
                                          {
                                              [self setImageDataWithIndex:selectedImageViewIndex imageData:array[0]];
                                              selectedImageViewIndex = -1;
                                          }
                                          else
                                          {
                                              [self setDataWithImageArray:array];
                                          }
                                          
                                      });
                   });
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    NSLog(@"info===%@",info);
    [picker dismissViewControllerAnimated:YES completion:^
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (selectedImageViewIndex != -1)
        {
            [self setImageDataWithIndex:selectedImageViewIndex imageData:image];
            selectedImageViewIndex = -1;
        }
        else
        {
            [self setDataWithImageArray:@[image]];
        }
    }];
}


@end
