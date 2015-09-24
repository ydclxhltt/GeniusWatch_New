//
//  MessageListViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "MessageListViewController.h"

//获取消息
#define LOADING_INFO         @"加载中..."
#define LOADING_INFO_SUCESS  @"加载成功"
#define LOADING_INFO_FAIL    @"加载失败"
//删除消息
#define LOADING_DEL          @"正在删除..."
#define LOADING_DEL_SUCESS   @"删除成功"
#define LOADING_DEL_FAIL     @"删除失败"

@interface MessageListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) int deleteIndex;
@property (nonatomic, strong) NSMutableArray *dataArrary;

@end

@implementation MessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    [self addBackItem];
    [self setNavBarItemWithTitle:@"         编辑" navItemType:RightItem selectorName:@"editButtonPressed:"];
    [self initUI];
    [self getMessageList];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
}


//添加表格
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) tableType:UITableViewStylePlain tableDelegate:self];
}


#pragma mark 获取消息列表
- (void)getMessageList
{
    [SVProgressHUD showWithStatus:LOADING_INFO];
    __weak typeof(self) weakSelf = self;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = imeiNo ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"mobileNo":[GeniusWatchApplication shareApplication].userName};
    [[RequestTool alloc] requestWithUrl:MESSAGE_LIST_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"MESSAGE_LIST_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_INFO_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             weakSelf.dataArrary = [NSMutableArray arrayWithArray:responseDic[@"msgs"]];
             [weakSelf.table reloadData];
             [SVProgressHUD showSuccessWithStatus:LOADING_INFO_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"MESSAGE_LIST_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_INFO_FAIL];
     }];
}

- (void)editButtonPressed:(UIButton *)sender
{
    self.table.editing = YES;
    [self setNavBarItemWithTitle:@"         完成" navItemType:RightItem selectorName:@"commitButtonPressed:"];
}

- (void)commitButtonPressed:(UIButton *)sender
{
    [self setNavBarItemWithTitle:@"         编辑" navItemType:RightItem selectorName:@"editButtonPressed:"];
    self.table.editing = NO;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArrary count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
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
    
    if (self.dataArrary && [self.dataArrary count] > 0)
    {
        NSDictionary *rowDic = self.dataArrary[indexPath.row];
        cell.textLabel.text = rowDic[@"EVENTCONTENT"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary *dic = self.dataArrary[indexPath.row];
        NSString *msgId = dic[@"ID"];
        msgId = msgId ? msgId : @"";
        self.deleteIndex = (int)indexPath.row;
        [self deleteMessageWithID:msgId];
    }
}


#pragma mark 删除消息
- (void)deleteMessageWithID:(NSString *)messageID
{
    [SVProgressHUD showWithStatus:LOADING_DEL];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"msg":messageID};
    [[RequestTool alloc] requestWithUrl:MESSAGE_DELETE_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"MESSAGE_DELETE_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_DEL_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [weakSelf.dataArrary removeObjectAtIndex:self.deleteIndex];
             [weakSelf.table reloadData];
             [SVProgressHUD showSuccessWithStatus:LOADING_DEL_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"MESSAGE_DELETE_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_DEL_FAIL];
     }];
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
