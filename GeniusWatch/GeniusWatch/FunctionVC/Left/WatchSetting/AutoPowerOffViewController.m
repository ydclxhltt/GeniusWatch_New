//
//  AutoPowerOffViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AutoPowerOffViewController.h"
#import "LeftRightLableCell.h"

#define SPACE_X         10.0
#define SPACE_Y         15.0
#define LABEL_HEIGHT    50.0
#define TIP_TEXT        @"注意:充电时,手表会一直保持开机状态,定时开关机不会生效."
@interface AutoPowerOffViewController ()

@end

@implementation AutoPowerOffViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"开关机时间";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma  mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addFooterView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addFooterView
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, LABEL_HEIGHT) placeholderImage:nil];
    UILabel *tipLable = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, imageView.frame.size.width - 2 * SPACE_X, LABEL_HEIGHT) textString:TIP_TEXT textColor:TIP_COLOR textFont:TIP_FONT];
    tipLable.numberOfLines = 2;
    [imageView addSubview:tipLable];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:TIP_TEXT];
    [CommonTool makeString:TIP_TEXT toAttributeString:string withString:@"注意:" withTextColor:APP_MAIN_COLOR withTextFont:TIP_FONT];
    tipLable.attributedText = string;
    
    self.table.tableFooterView = imageView;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(0, SPACE_X, 0, 0);
    }

    NSString *poweroffTime = self.dataDic[@"poweroffTime"];
    poweroffTime = (poweroffTime) ? poweroffTime : @"";
    NSString *poweronTime = self.dataDic[@"poweronTime"];
    poweronTime = (poweronTime) ? poweronTime : @"";
    [cell setDataWithLeftText:(indexPath.row == 0) ? @"开机时间" : @"关机时间" rightText:(indexPath.row == 0) ? poweronTime : poweroffTime];
    
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
