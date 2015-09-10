//
//  AddWatchViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddWatchViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomAddWatchViewController.h"

#define SPACE_Y             NAVBAR_HEIGHT + 20.0 * CURRENT_SCALE
#define SCNNING_WH          200.0
#define TIP_LABEL_HEIGHT    30.0
#define SCANNING_TIP        @"将手表二维码放在扫描框内,即可自动扫描"
#define ADD_Y               25.0 * CURRENT_SCALE
#define BUTTON_SPACE_X      30.0 * CURRENT_SCALE

@interface AddWatchViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrDown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView *lineImageView;
@end

@implementation AddWatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackItem];
    if (self.showType == ShowTypePush)
    {
        [self setNavBarItemWithTitle:@"" navItemType:LeftItem selectorName:@""];
    }
    
    self.title = @"扫描手表二维码";
    
    upOrDown = NO;
    num =0;
    
    [self initUI];
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTimer];
}

#pragma mark 返回按钮
- (void)backButtonPressed:(UIButton *)sender
{
    if (self.showType == ShowTypePush)
    {
        
    }
    else if (self.showType == ShowTypePresent)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [timer invalidate];
        }];
    }

}


#pragma mark 初始化UI
- (void)initUI
{
    UIImage *image = [UIImage imageNamed:@"scanning_tip"];
    float tipWidth = image.size.width/3 * CURRENT_SCALE;
    float tipHeight = image.size.height/3 * CURRENT_SCALE;
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake((self.view.frame.size.width - tipWidth)/2, SPACE_Y, tipWidth, tipHeight) placeholderImage:image];
    [self.view addSubview:imageView];
    
    start_y = imageView.frame.origin.y + imageView.frame.size.height + ADD_Y;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self setupCamera];
    }

    UIImage *pickBgImage = [UIImage imageNamed:@"pick_bg"];
    //float pickBgImageWidth = pickBgImage.size.width/3;
    //float pickBgImageHeight = pickBgImage.size.height/3;
    UIImageView * interImageView = [CreateViewTool createImageViewWithFrame:CGRectMake((self.view.frame.size.width - SCNNING_WH)/2, start_y, SCNNING_WH, SCNNING_WH) placeholderImage:pickBgImage];
    [self.view addSubview:interImageView];

    UIImage *lineImage = [UIImage imageNamed:@"line"];
    float lineImageWidth = lineImage.size.width/3;
    float lineImageHeight = lineImage.size.height/3;
    float lineSpace_x = (pickBgImage.size.width - lineImageWidth)/2;
    _lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(lineSpace_x, 0, SCNNING_WH - 2 * lineSpace_x, lineImageHeight) placeholderImage:[UIImage imageNamed:@"line"]];
    [interImageView addSubview:_lineImageView];
    
    start_y += interImageView.frame.size.height;
    
    UILabel * tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, TIP_LABEL_HEIGHT) textString:SCANNING_TIP textColor:[UIColor lightGrayColor] textFont:FONT(12.0)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
     start_y = tipLabel.frame.origin.y + tipLabel.frame.size.height + ADD_Y;
    UIButton *nextButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, start_y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"手动输入绑定号" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"autoButtonPressed:" tagDelegate:self];
    nextButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:nextButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:nextButton];
}


#pragma mark 初始化SCANNING
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = CGRectMake((self.view.frame.size.width - SCNNING_WH)/2, start_y, SCNNING_WH, SCNNING_WH);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    // Start
    [_session startRunning];
}


#pragma mark 动画定时器
-(void)createTimer
{
    if ([timer isValid])
    {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
}

//动画
-(void)lineAnimation
{
    CGRect frame = _lineImageView.frame;
    if (upOrDown == NO)
    {
        num++;
        
        if (2 * num >= SCNNING_WH)
        {
            upOrDown = YES;
        }
    }
    else
    {
        num --;
        if (2 * num <= 0)
        {
            upOrDown = NO;
        }
    }
    _lineImageView.frame = CGRectMake(frame.origin.x, 2 * num, frame.size.width, frame.size.height);
    
}


#pragma mark 手动输入相应事件
- (void)autoButtonPressed:(UIButton *)sender
{
    CustomAddWatchViewController *autoAddWatchViewController = [[CustomAddWatchViewController alloc] init];
    [self.navigationController pushViewController:autoAddWatchViewController animated:YES];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [timer invalidate];
    NSLog(@"%@",stringValue);
    [CommonTool addAlertTipWithMessage:stringValue];
//    [self dismissViewControllerAnimated:YES completion:^
//     {
//         [timer invalidate];
//         NSLog(@"%@",stringValue);
//         [CommonTool addAlertTipWithMessage:stringValue];
//     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

