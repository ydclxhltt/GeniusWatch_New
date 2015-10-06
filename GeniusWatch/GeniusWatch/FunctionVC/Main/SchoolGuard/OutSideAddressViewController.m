//
//  OutSideAddressViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/10/5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "OutSideAddressViewController.h"
#import "BMapKit.h"
#import "SearchResultViewController.h"

#define SEARCHBAR_HEIGHT    30.0
#define IMAGEVIEW_HEIGHT    35.0 * CURRENT_SCALE
#define ADD_X               10.0 * CURRENT_SCALE
#define ADD_Y               5.0

@interface OutSideAddressViewController ()<UISearchBarDelegate,BMKPoiSearchDelegate,UIScrollViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    BMKPoiSearch *pioSearch;
    BMKLocationService *locationService;
    BMKGeoCodeSearch *geocodesearch;
    BOOL isSearch;
}

@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation OutSideAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    [self initUI];
    isSearch = NO;
    [self getNearByPlaceWithKeyWord:(self.addressType == SetAddressTypeSchool) ? @"学校" : @"小区"];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addSearchBar];
    [self addHeaderView];
    [self addTableView];
}

- (void)addSearchBar
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入要搜索的地址";
    self.navigationItem.titleView = _searchBar;
}

- (void)addHeaderView
{
    
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, NAVBAR_HEIGHT + ADD_Y, self.view.frame.size.width, IMAGEVIEW_HEIGHT) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    float button_width = imageView.frame.size.width/2;
    float button_height = imageView.frame.size.height;
    NSArray *titleArray = @[@"手表当前位置",@"手机当前位置"];
    NSArray *imageArray = @[@"personal_watch_icon",@"personal_phone"];
    
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        float image_height = image.size.height/3 * CURRENT_SCALE;
        float image_width = image.size.width/3 * CURRENT_SCALE;
        float title_width = [titleArray[i] sizeWithAttributes:@{NSFontAttributeName : BUTTON_FONT}].width;
        float space_x = (button_width - ADD_X - image_width - title_width)/2;
        float space_y = (button_height - image_height)/2;
        
        UIImageView *iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(space_x + i * button_width, space_y, image_width, image_height) placeholderImage:image borderColor:nil imageUrl:nil];
        [imageView addSubview:iconImageView];
        
        UILabel *titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + ADD_X , 0, title_width, button_height) textString:titleArray[i] textColor:[UIColor blackColor] textFont:BUTTON_FONT];
        [imageView addSubview:titleLabel];
        
        UIButton *button = [CreateViewTool  createButtonWithFrame:CGRectMake(i * button_width, 0, button_width, button_height) buttonTitle:nil titleColor:nil normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"locationButtonPressed:" tagDelegate:self];
        button.tag = 100 + i;
        [imageView addSubview:button];
    }
    
    start_y = imageView.frame.size.height + imageView.frame.origin.y;

    UIImageView *sepImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, ADD_Y) placeholderImage:nil];
    sepImageView.backgroundColor = SECTION_HEADER_COLOR;
    [self.view addSubview:sepImageView];
    
    start_y += sepImageView.frame.size.height;
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, self.view.frame.size.height - start_y) tableType:UITableViewStylePlain tableDelegate:self];
}

#pragma mark  定位相关
- (void)setLocation
{
    locationService = [[BMKLocationService alloc]init];
    //定位的最小更新距离
    [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
    //定位精确度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)startLocation
{
    locationService.delegate = self;
    [locationService startUserLocationService];
}


- (void)stopLocation
{
    locationService.delegate = nil;
    [locationService stopUserLocationService];
    
}

#pragma mark 位置按钮
- (void)locationButtonPressed:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    if (index == 0)
    {
        NSDictionary *dic = self.dataDic[@"lastPosition"][@"point"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
        NSDictionary *dict = BMKConvertBaiduCoorFrom(coordinate,BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dict); // 转换为百度地图所需要的经纬度
        coordinate = baiduCoor;
        NSString *address = NO_NULL(self.dataDic[@"lastPosition"][@"poi"]);
        [self changeDataWithAddress:address coordinate:coordinate];
    }
    else
    {
         [self changeDataWithAddress:self.addressString  coordinate:self.locationCoordinate];
    }
    
}

#pragma mark 附近
- (void)getNearByPlaceWithKeyWord:(NSString *)keyword
{
    if (!pioSearch)
    {
        pioSearch = [[BMKPoiSearch alloc] init];
        pioSearch.delegate = self;
    }
    BMKNearbySearchOption *nearbySearch = [[BMKNearbySearchOption alloc] init];
    nearbySearch.keyword = NO_NULL(keyword);
    nearbySearch.location = self.searchCoordinate;
    nearbySearch.radius = 1500;
    nearbySearch.pageCapacity = 20.0;
    BOOL flag = [pioSearch poiSearchNearBy:nearbySearch];
    if(flag)
    {
        NSLog(@"附近检索发送成功");
    }
    else
    {
        NSLog(@"附近检索发送失败");
    }
}


#pragma mark UISearchBarDlegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = NO_NULL(searchBar.text);
    if (text.length > 0)
    {
        //下一页
        isSearch = YES;
        [self getNearByPlaceWithKeyWord:text];
    }
    [searchBar resignFirstResponder];
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"userLocation====%@",[userLocation.location description]);
    self.locationCoordinate = userLocation.location.coordinate;
    [self getReverseGeocodeWithLocation:userLocation.location.coordinate];
    [self stopLocation];
}

#pragma mark 编译地址
- (void)getReverseGeocodeWithLocation:(CLLocationCoordinate2D)locaotion
{
    NSLog(@"locaotion===%f===%f",locaotion.latitude,locaotion.longitude);
    if (!geocodesearch)
    {
        geocodesearch = [[BMKGeoCodeSearch alloc] init];
        geocodesearch.delegate = self;
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = locaotion;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


#pragma mark 坐标转换地址Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result====%@",[result  address]);
    self.addressString = [result  address];
}

#pragma mark BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    NSLog(@"poiResult===%@",poiResult.poiInfoList);
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        if (!isSearch)
        {
            self.dataArray = poiResult.poiInfoList;
            [self.table reloadData];
        }
        else
        {
            //
            isSearch = NO;
            SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] init];
            searchResultViewController.dataArray = poiResult.poiInfoList;
            searchResultViewController.addressType = self.addressType;
            searchResultViewController.dataDic = self.dataDic;
            [self.navigationController pushViewController:searchResultViewController animated:YES];
        }

    }
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20.0) textString:@"  附近地点" textColor:SECTION_LABEL_COLOR textFont:FONT(13.0)];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.transform = CGAffineTransformMakeScale(.5, .5);
    }
    if (self.dataArray && [self.dataArray count] > 0)
    {
        BMKPoiInfo* poi = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = poi.name;
        cell.textLabel.font = FONT(16.0);
    }
    cell.imageView.image = [UIImage imageNamed:@"chat_location_watch"];
    return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPoiInfo* poi = [self.dataArray objectAtIndex:indexPath.row];
    [self changeDataWithAddress:poi.name coordinate:poi.pt];
}

- (void)changeDataWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    NSMutableDictionary *ownerDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"owner"]];
    [ownerDic setValue:address forKey:(self.addressType == SetAddressTypeHouse) ? @"homePoi" : @"schoolPoi"];
    NSMutableDictionary *positionDic = [NSMutableDictionary dictionaryWithDictionary:(self.addressType == SetAddressTypeHouse) ? ownerDic[@"homeLngLat"] : ownerDic[@"schoolLngLat"]];
    [positionDic setValue:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"lat"];
    [positionDic setValue:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"lng"];
    [ownerDic setValue:positionDic forKey:(self.addressType == SetAddressTypeHouse) ? @"homeLngLat" : @"schoolLngLat"];
    [self.dataDic setValue:ownerDic forKey:@"owner"];
    [self.navigationController popToViewController:self.navigationController.viewControllers[3] animated:YES];
}

- (void)dealloc
{
    pioSearch.delegate = nil;
    pioSearch = nil;
    locationService.delegate = nil;
    locationService = nil;
    geocodesearch.delegate = nil;
    geocodesearch = nil;
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
