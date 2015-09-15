//
//  WatchInfoViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "WatchInfoViewController.h"
#import "LeftRightLableCell.h"
#import "BabyIocnView.h"

@interface WatchInfoViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *referLabel;
@property (nonatomic, strong) BabyIocnView *babyIocnView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *headerHeightArray;

@end

@implementation WatchInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"宝贝资料";
    [self addBackItem];
    
    self.headerHeightArray = @[@(2.0),@(10.0),@(10.0)];
    self.titleArray = @[@[@"手表号码",@"手边短号/亲情号"],@[@"性别",@"生日",@"年级"],@[@"学校信息",@"家-小区信息"]];
    NSArray *array  = @[@[@"18625353676",@"8888"],@[@"男",@"2013-12-16",@"幼儿园"],@[@"外国语小学",@"信合金色阳光"]];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addTableViewHeader];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}


- (void)addTableViewHeader
{
    float space_y = 10.0;
    float space_x = 25.0 * CURRENT_SCALE;
    float add_x = 15.0;
    UIImage *babyImage = [UIImage imageNamed:@"baby_head_up"];
    float babyWidth = babyImage.size.width/3 * CURRENT_SCALE;
    float babyHeight = babyImage.size.height/3 * CURRENT_SCALE + INFO_LABLE_HEIGHT;
    
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, babyHeight + space_y) placeholderImage:nil];
    [self.table setTableHeaderView:bgImageView];
    
    _babyIocnView = [[BabyIocnView alloc] initWithFrame:CGRectMake(space_x, space_y, babyWidth, babyHeight)];
    [bgImageView addSubview:_babyIocnView];
    [_babyIocnView setImageWithUrl:nil defaultImage:@"baby_head_up" infoLableText:@"修改头像"];
    
    float x  = _babyIocnView.frame.origin.x + _babyIocnView.frame.size.width + add_x;
    float height = (babyHeight - INFO_LABLE_HEIGHT)/2;
    float width = bgImageView.frame.size.width - babyWidth - 2 * space_x - add_x;
    _nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, space_y, width, height) textString:@"宝贝" textColor:[UIColor blackColor] textFont:FONT(16.0)];
    [bgImageView addSubview:_nameLabel];
    
    float y = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    _nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, width, height) textString:@"我与宝贝的关系是:" textColor:TIP_COLOR textFont:FONT(17.0)];
    [bgImageView addSubview:_nameLabel];
    
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.headerHeightArray[section] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self.headerHeightArray[section] floatValue]) textString:@"" textColor:SECTION_LABEL_COLOR textFont:FONT(12.0)];
    label.backgroundColor = SECTION_HEADER_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";

    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
    }
        
    [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
        
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
