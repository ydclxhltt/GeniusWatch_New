//
//  MemberListViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/8.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "ChatMemberListViewController.h"

#define ROW_HEIGHT  50.0


@interface ChatMemberListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ChatMemberListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微聊成员";
    [self addBackItem];
    [self initUI];
    self.dataArray = @[@"手表",@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"姐姐",@"妹妹",@"弟弟",@"哥哥"];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.imageView.transform = CGAffineTransformMakeScale(.5, .5);
    }
    
    cell.imageView.image = [UIImage imageNamed:@"default_icon"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = FONT(16.0);
    
    return cell;
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
