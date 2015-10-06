//
//  AboutUsViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/16.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UserNoticeViewController.h"

#define SPACE_Y             15.0 * CURRENT_SCALE
#define ADD_Y               10.0 * CURRENT_SCALE
#define HEADERVIEW_HEIGHT   190.0 * CURRENT_SCALE
#define LABEL_HEIGHT        20.0 * CURRENT_SCALE
#define BG_LINE_HEIGHT      5.0 * CURRENT_SCALE

@interface AboutUsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"关于";
    _dataArray = @[@"分享好友",@"去评分",@"用户服务协议"];
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addHeaderView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addHeaderView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADERVIEW_HEIGHT) placeholderImage:nil];
    UIImage *image = [UIImage imageNamed:@"app_set_icon"];
    float width = image.size.width/3 * CURRENT_SCALE;
    float height = image.size.height/3 * CURRENT_SCALE;
    float x = (bgImageView.frame.size.width - width)/2;
    float y = SPACE_Y;
    UIImageView *iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, width, height) placeholderImage:image];
    [bgImageView addSubview:iconImageView];
    
    y += iconImageView.frame.size.height + ADD_Y;
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, y, bgImageView.frame.size.width, LABEL_HEIGHT) textString:@"电话手表" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    label.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label];
    
    y += label.frame.size.height + ADD_Y/2;
    UILabel *versionLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, y, bgImageView.frame.size.width, LABEL_HEIGHT) textString:@"版本1.0.0(8)" textColor:TIP_COLOR textFont:FONT(17.0)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:versionLabel];
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, bgImageView.frame.size.height - BG_LINE_HEIGHT, bgImageView.frame.size.width, BG_LINE_HEIGHT) placeholderImage:nil];
    lineImageView.backgroundColor = SECTION_HEADER_COLOR;
    [bgImageView addSubview:lineImageView];
    
    [self.table setTableHeaderView:bgImageView];
}


#pragma mark UITableViewDelgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2)
    {
        UserNoticeViewController *userNoticeViewController = [[UserNoticeViewController alloc] init];
        [self.navigationController pushViewController:userNoticeViewController animated:YES];
    }
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
