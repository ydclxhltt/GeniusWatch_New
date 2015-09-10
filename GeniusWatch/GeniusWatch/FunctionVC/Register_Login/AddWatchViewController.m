//
//  AddWatchViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddWatchViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AutoAddWatchViewController.h"

#define SPACE_Y             NAVBAR_HEIGHT + 10.0 * CURRENT_SCALE
#define SCNNING_WH          280.0
#define TIP_LABEL_HEIGHT    30.0
#define SCANNING_TIP        @"请将手表二维码,放在方框内"
#define ADD_Y               30.0 * CURRENT_SCALE
#define LINE_SPACE_X        30.0
#define LINE_HEIGHT         5.0
#define SPACE_X             40.0 * CURRENT_SCALE

@interface AddWatchViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
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
    self.title = @"扫描";
    self.view.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.5);
    
    upOrdown = NO;
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
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}


#pragma mark 初始化UI
- (void)initUI
{
    UILabel * tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, SPACE_Y, self.view.frame.size.width, TIP_LABEL_HEIGHT) textString:SCANNING_TIP textColor:[UIColor whiteColor] textFont:FONT(16.0)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    start_y = tipLabel.frame.origin.y + tipLabel.frame.size.height + ADD_Y;
    
     [self setupCamera];
    
    UIImageView * interImageView = [CreateViewTool createImageViewWithFrame:CGRectMake((self.view.frame.size.width - SCNNING_WH)/2, start_y, SCNNING_WH, SCNNING_WH) placeholderImage:[UIImage imageNamed:@"pick_bg"]];
    [self.view addSubview:interImageView];

    _lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(LINE_SPACE_X, 0, SCNNING_WH - 2 * LINE_SPACE_X, LINE_HEIGHT) placeholderImage:[UIImage imageNamed:@"line"]];
    [interImageView addSubview:_lineImageView];
    
    start_y += interImageView.frame.size.height + ADD_Y;
    
    UIButton *nextButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"手动输入绑定号" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:[UIColor grayColor] selectorName:@"autoButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:nextButton withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
    [CommonTool clipView:nextButton withCornerRadius:15.0];
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
    if (upOrdown == NO)
    {
        num++;
        
        if (2 * num > SCNNING_WH - LINE_HEIGHT)
        {
            upOrdown = YES;
        }
    }
    else
    {
        num --;
        if (num < LINE_HEIGHT)
        {
            upOrdown = NO;
        }
    }
    _lineImageView.frame = CGRectMake(frame.origin.x, 2 * num, frame.size.width, frame.size.height);
    
}


#pragma mark 手动输入相应事件
- (void)autoButtonPressed:(UIButton *)sender
{
    AutoAddWatchViewController *autoAddWatchViewController = [[AutoAddWatchViewController alloc] init];
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
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
         NSLog(@"%@",stringValue);
         [CommonTool addAlertTipWithMessage:stringValue];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

