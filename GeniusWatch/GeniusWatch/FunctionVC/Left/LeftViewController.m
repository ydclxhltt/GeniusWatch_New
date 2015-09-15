//
//  LeftViewController.m
//  GeniusWatch
//
//  Created by clei on 15/8/21.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LeftViewController.h"
#import "PageFlowView.h"
#import "AddWatchViewController.h"
#import "AboutWatchViewController.h"
#import "WatchSettingViewController.h"
#import "WatchInfoViewController.h"


#define NUMBER_OF_VISIBLE_ITEMS     2
#define INCLUDE_PLACEHOLDERS        YES
#define SPACE_Y                     64.0
#define ROW_HEIGHT                  80.0 * CURRENT_SCALE
#define ADD_Y                       60.0 * CURRENT_SCALE
#define SPACE_X                     47.0 * CURRENT_SCALE


@interface LeftViewController ()<PageFlowViewDelegate,PageFlowViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    float flowViewHeight;
    float flowViewWidth;
}

@property (nonatomic, strong) PageFlowView  *flowView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *babyDevicesArray;
@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.titleArray = @[@"宝贝资料",@"手表设置",@"关于手表"];
    self.imageArray = @[@"personal_baby",@"personal_watch_set",@"personal_watch"];
    
    [self initUI];
    
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addBgImageView];
    [self addCoverFlowView];
    [self addTableView];
}

//添加背景图
- (void)addBgImageView
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) placeholderImage:[UIImage imageNamed:(SCREEN_HEIGHT == 480.0) ? @"left_bg1" : @"left_bg2"]];
    [self.view addSubview:imageView];
}

//添加头视图
- (void)addCoverFlowView
{
    //create carousel
    UIImage *image = [UIImage imageNamed:@"baby_head_up"];
    flowViewHeight = image.size.height * 2 / 5 * CURRENT_SCALE;
    flowViewWidth = image.size.width * 2 /5 * CURRENT_SCALE;
    
    _flowView = [[PageFlowView alloc] initWithFrame:CGRectMake(0, SPACE_Y, LEFT_SIDE_WIDTH, flowViewHeight)];
    _flowView.delegate = self;
    _flowView.dataSource = self;
    _flowView.minimumPageAlpha = 0.6;
    _flowView.minimumPageScale = 0.7;
    _flowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_head_up"]];
    [self.view addSubview:_flowView];
    
    [self initDevicesData];
   
}

//添加tableView
- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(SPACE_X, _flowView.frame.size.height + _flowView.frame.origin.y + ADD_Y, LEFT_SIDE_WIDTH - SPACE_X, ROW_HEIGHT * [self.titleArray count]) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

#pragma mark 初始化数据
- (void)initDevicesData
{
    self.babyDevicesArray = [NSMutableArray arrayWithArray:[GeniusWatchApplication shareApplication].deviceList];
    if ([self.babyDevicesArray count] < 5)
    {
        [self.babyDevicesArray addObject:@{@"headShot":@"personal_add"}];
    }
    [_flowView reloadData];
}

#pragma mark 设置图片
- (void)setImageForView:(UIImageView *)imageView withIndex:(int)index
{
    NSDictionary *dic = self.babyDevicesArray[index];
    NSString *url = dic[@"headShot"];
    url = url ? url : @"";
    if ([@"personal_add" isEqualToString:url])
    {
        imageView.image = [UIImage imageNamed:url];
    }
    else
    {
        url = @"http://p1.qqyou.com/touxiang/UploadPic/2014-7/24/2014072412362223172.jpg";
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"baby_head_up"]];
    }
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = FONT(16.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int index = (int)indexPath.row;
    UIViewController *viewController = nil;
    switch (index)
    {
        case 0:
            viewController = [[WatchInfoViewController alloc] init];
            break;
        case 1:
            viewController = [[WatchSettingViewController alloc] init];
            break;
        case 2:
            viewController = [[AboutWatchViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PageFlowView *)flowView
{
    return [self.babyDevicesArray count];
}

- (CGSize)sizeForPageInFlowView:(PageFlowView *)flowView
{
    return CGSizeMake(flowViewWidth, flowViewHeight);
}

//返回给某列使用的View
- (UIView *)flowView:(PageFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView)
    {
        imageView = [[UIImageView alloc] init] ;
    }
    [self setImageForView:imageView withIndex:(int)index];
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
    [self setImageForView:imageView withIndex:(int)index];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PageFlowView *)flowView
{
    NSLog(@"Scrolled to page # %ld", (long)pageNumber);
}

- (void)didSelectItemAtIndex:(NSInteger)index inFlowView:(PageFlowView *)flowView
{
    NSLog(@"didSelectItemAtIndex: %ld", (long)index);
    if (index == [self.babyDevicesArray count] - 1 && [[GeniusWatchApplication shareApplication].deviceList count]< 5)
    {
        [self addBabyWatch];
    }
}

#pragma mark 添加手表
- (void)addBabyWatch
{
    AddWatchViewController *addWatchViewController = [[AddWatchViewController alloc] init];
    addWatchViewController.showType = ShowTypePresent;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addWatchViewController];
    [self presentViewController:nav animated:YES completion:^{}];
}



- (void)didReceiveMemoryWarning {
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
