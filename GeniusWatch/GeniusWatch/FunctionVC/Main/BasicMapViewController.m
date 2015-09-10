//
//  BasicMapViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicMapViewController.h"

#define SPACE_Y         150.0 * CURRENT_SCALE
#define SPACE_X         20.0
#define BAR_SPACE_X     100.0
#define BAR_SPACE_Y     30.0
#define ZOOM_ADD        0.5
#define ZOOM_SPACE_X    20.0
#define ADD_Y           5.0

@interface BasicMapViewController ()

@end

@implementation BasicMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setAboutLocationDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self setAboutLocationDelegate:nil];
}

#pragma mark 设置定位/地图代理
- (void)setAboutLocationDelegate:(id)delegate
{
    if (_mapView)
        _mapView.delegate = delegate;
}


#pragma mark  添加地图
- (void)addMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate = self;
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.zoomLevel = 15.0;
    self.mapView.showsUserLocation = NO;
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(self.mapView.frame.size.width - BAR_SPACE_X, self.mapView.frame.size.height - BAR_SPACE_Y);
    [self.view addSubview:self.mapView];
}


#pragma mark  添加模式切换按钮
- (void)addTypeButton
{
    UIImage *image = [UIImage imageNamed:@"location_map_model_up"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    UIButton *typeButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.view.frame.size.width - SPACE_X - width, SPACE_Y, width, height) buttonImage:@"location_map_model" selectorName:@"typeButtonPressed:" tagDelegate:self];
    [typeButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.view addSubview:typeButton];
}


#pragma mark  添加更新按钮
- (void)addLocationButton
{
    UIImage *image = [UIImage imageNamed:@"location_location_up"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    UIButton *locaitonButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.view.frame.size.width - SPACE_X - width, self.view.frame.size.height - (BAR_SPACE_Y) - height, width, height) buttonImage:@"location_location" selectorName:@"locationButtonPressed:" tagDelegate:self];
    [self.view addSubview:locaitonButton];
    
    start_y = locaitonButton.frame.origin.y - ADD_Y;
}

#pragma mark  添加缩放按钮
- (void)addZoomButton
{
    NSArray *imageArray = @[@"location_zoom_shrink",@"location_zoom_amplification"];
    UIImage *image = [UIImage imageNamed:@"location_zoom_amplification_up"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    
    for (int i = 0; i  < [imageArray count]; i++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(self.view.frame.size.width - ZOOM_SPACE_X - width, start_y - (i + 1) * height, width, height) buttonImage:imageArray[i] selectorName:@"zoomButtonPressed:" tagDelegate:self];
        button.tag = i + 1;
        [self.view addSubview:button];
    }
}


#pragma mark 切换地图模型按钮响应事件
- (void)typeButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.mapView.mapType = (!sender.selected) ? BMKMapTypeStandard : BMKMapTypeSatellite;
}


#pragma mark 定位按钮事件
- (void)locationButtonPressed:(UIButton *)sender
{
    
}


#pragma  mark 放大缩小按钮
- (void)zoomButtonPressed:(UIButton *)sender
{
    int tag = (int)sender.tag;
    self.mapView.zoomLevel += ((tag == 1) ? -1 : 1) * ZOOM_ADD;
}


- (void)dealloc
{
    if (self.mapView)
    {
        self.mapView = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
