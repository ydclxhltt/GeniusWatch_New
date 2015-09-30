//
//  SoundSharkViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SoundSharkViewController.h"

//表
#define HEADER_HEIGHT        25.0

@interface SoundSharkViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SoundSharkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"声音和振动";
    [self addBackItem];
    _dataArray = @[@"callBellSwitch",@"callShakeSwitch",@"msgBellSwitch",@"msgVibrateSwitch"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT) textString:(section == 0) ? @" 手表来电" : @" 手表消息" textColor:SECTION_LABEL_COLOR textFont:FONT(12.0)];
    label.backgroundColor = SECTION_HEADER_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = (indexPath.row == 0) ? @"铃声" : @"振动";
    
    UISwitch *switchView = [[UISwitch alloc] init];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    int index = (int)(indexPath.section * 2 + indexPath.row);
    switchView.tag = index + 1;
    cell.accessoryView = switchView;
    [switchView setOn:[self.dataDic[self.dataArray[index]] integerValue]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark 开关控制
- (void)switchChanged:(UISwitch *)switchView
{
    int index = (int)switchView.tag - 1;
    [self.dataDic setValue:[NSString stringWithFormat:@"%d",switchView.isOn] forKey:self.dataArray[index]];
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
