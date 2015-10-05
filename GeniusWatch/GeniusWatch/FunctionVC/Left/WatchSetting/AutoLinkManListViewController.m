//
//  AutoLinkManListViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AutoLinkManListViewController.h"
#import "LinkManListCell.h"

#define SECTION_HEIGHT   25.0
#define ROW_HEIGHT       75.0

@interface AutoLinkManListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AutoLinkManListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"自动接通";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)backButtonPressed:(UIButton *)sender
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.autoArray];
    [array addObjectsFromArray:self.noAutoArray];
    [self.dataDic setValue:array forKey:@"autoCall"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) tableType:UITableViewStylePlain tableDelegate:self];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(section == 0) ? self.autoArray : self.noAutoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), SECTION_HEIGHT) textString:(section == 0) ? @"  绑定手表联系人" : @"  普通联系人" textColor:SECTION_LABEL_COLOR textFont:FONT(12.0)];
    label.backgroundColor =  SECTION_HEADER_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    LinkManListCell *cell = (LinkManListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LinkManListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSMutableArray *array = (indexPath.section == 0) ? self.autoArray : self.noAutoArray;
    NSDictionary *rowDic = array[indexPath.row];
    [cell setContactDataWithDictionary:rowDic];
    
    UIImageView *imageView = (UIImageView *)cell.accessoryView;
    if (indexPath.section == 0)
    {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryView = imageView;
        NSString *autoCall = self.noAutoArray[indexPath.row][@"allowAutoAcceptCall"];
        if (autoCall && ![autoCall isKindOfClass:[NSNull class]])
        {
            imageView.image = [UIImage imageNamed:([autoCall integerValue] == 1) ? @"seclected" : @"no_seclected"];
        }
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.noAutoArray[indexPath.row]];
        int autoCall = [dic[@"allowAutoAcceptCall"] intValue];
        autoCall = !autoCall;
        [dic setValue:[NSString stringWithFormat:@"%d",autoCall] forKey:@"allowAutoAcceptCall"];
        [self.noAutoArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.table reloadData];
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
