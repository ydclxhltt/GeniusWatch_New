//
//  SearchResultViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/10/6.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    self.title = @"搜索结果";
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
}



- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
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
