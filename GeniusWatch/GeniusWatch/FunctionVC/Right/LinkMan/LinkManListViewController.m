//
//  LinkManListViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LinkManListViewController.h"
#import "AddLinkManViewController.h"

#define SECTION_HEIGHT   10.0
#define HEADER_HEIGHT    120.0

#define BUTTON_SPACE_X   20.0 * CURRENT_SCALE
#define BUTTON_SPACE_Y   10.0
#define BUTTON_HEIGHT    40.0
#define FOOTER_HEIGHT    80.0

@interface LinkManListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *watchOwnerLable;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *shortNumberLable;

@end

@implementation LinkManListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    self.title = @"通讯录";
    
    [self initUI];
    
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addTableViewHeader];
    [self addButtons];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - FOOTER_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.backgroundColor = SECTION_HEADER_COLOR;
}

- (void)addTableViewHeader
{
    float space_y  = 10.0;
    float space_x = 40.0 * CURRENT_SCALE;
    float add_x = 20.0 * CURRENT_SCALE;
    UIImage *iconImage = [UIImage imageNamed:@"watch_icon"];
    float iconWidth = iconImage.size.width/3 * CURRENT_SCALE;
    float iconHeight = iconImage.size.height/3 * CURRENT_SCALE;
    
    float height = iconHeight + 2 * space_y;
    
    UIImageView *imageView = [CreateViewTool  createImageViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height) placeholderImage:nil];
    imageView.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = imageView;
    
    UIImageView *iconBgView = [CreateViewTool createImageViewWithFrame:CGRectMake(space_x, space_y, iconWidth, iconHeight) placeholderImage:iconImage];
    [imageView addSubview:iconBgView];
    
    float x = iconBgView.frame.origin.x + iconBgView.frame.size.width + add_x;
    float y = iconBgView.frame.origin.y;
    float labelHeight = iconBgView.frame.size.height/3;
    float labelWidth = imageView.frame.size.width - x - space_x;
    _watchOwnerLable = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, labelWidth, labelHeight) textString:@"手表主人:" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [imageView addSubview:_watchOwnerLable];
    
    y += _watchOwnerLable.frame.size.height;
    
    _phoneNumberLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, labelWidth, labelHeight) textString:@"手表号码:" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [imageView addSubview:_phoneNumberLabel];
    
     y += _phoneNumberLabel.frame.size.height;
    _shortNumberLable = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, labelWidth, labelHeight) textString:@"短号/亲情号:" textColor:[UIColor blackColor]  textFont:FONT(15.0)];
    [imageView addSubview:_shortNumberLable];
    
}

- (void)addButtons
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - FOOTER_HEIGHT, CGRectGetWidth(self.view.frame), FOOTER_HEIGHT) placeholderImage:nil];
    [self.view addSubview:bgImageView];
    
    UIButton *addButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, bgImageView.frame.size.height - BUTTON_HEIGHT - BUTTON_SPACE_Y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"添加联系人" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"addLinkManButtonPressed:" tagDelegate:self];
    addButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:addButton withCornerRadius:BUTTON_RADIUS];
    [bgImageView addSubview:addButton];
    
    float buttonWidth = bgImageView.frame.size.width/2;
    float buttonHeight = bgImageView.frame.size.height - addButton.frame.size.height -  BUTTON_SPACE_Y;
    NSArray *array = @[@"打不通电话?",@"同步不了联系人?"];
    for (int i = 0; i < 2; i++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight) buttonTitle:array[i] titleColor:[UIColor lightGrayColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"tipButtonPressed:" tagDelegate:self];
        button.titleLabel.font = FONT(12.0);
        [bgImageView addSubview:button];
    }
}

#pragma mark 提示按钮响应时间
- (void)tipButtonPressed:(UIButton *)sender
{
    
}

#pragma mark 添加联系人
- (void)addLinkManButtonPressed:(UIButton *)sender
{
    AddLinkManViewController *addLinkManViewController = [[AddLinkManViewController alloc] init];
    [self.navigationController pushViewController:addLinkManViewController animated:YES];
}


#pragma mark UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), SECTION_HEIGHT) textString:@"" textColor:nil textFont:nil];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
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
