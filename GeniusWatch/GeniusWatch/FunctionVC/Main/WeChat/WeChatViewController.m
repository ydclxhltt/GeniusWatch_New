//
//  WeChatViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/7.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "WeChatViewController.h"
#import "ChatMemberListViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

@interface WeChatViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) MJRefreshHeaderView *refreshHeaderView;
@property (strong, nonatomic) ChatModel *chatModel;
@property (strong, nonatomic) UITableView *chatTableView;

@end

@implementation WeChatViewController
{
    UUInputFunctionView *inputView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微聊";
    [self addBackItem];
    [self setNavBarItemWithImageName:@"chat_member" navItemType:RightItem selectorName:@"memberButtonPressed:"];
    [self initUI];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
}

//添加表格
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40.0) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView = self.table;
}

//添加刷新视图
- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;
    
    _refreshHeaderView = [MJRefreshHeaderView header];
    _refreshHeaderView.scrollView = self.chatTableView;
    _refreshHeaderView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
        
        if (weakSelf.chatModel.dataSource.count > pageNum) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.chatTableView reloadData];
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        [weakSelf.refreshHeaderView endRefreshing];
    };
}

//添加输入框
- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource];
    
    inputView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark 通讯录按钮响应事件
- (void)memberButtonPressed:(UIButton *)sender
{
    ChatMemberListViewController *chatMemberListViewController = [[ChatMemberListViewController alloc] init];
    [self.navigationController pushViewController:chatMemberListViewController animated:YES];
}


#pragma mark 键盘弹出消失通知
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardEndFrame = [value CGRectValue].size;
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    float add_y = (notification.name == UIKeyboardWillShowNotification) ? - keyboardEndFrame.height : 0.0;
    self.chatTableView.transform = CGAffineTransformMakeTranslation(0, add_y);
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = inputView.frame;
    newFrame.origin.y = (notification.name == UIKeyboardWillShowNotification) ? self.view.frame.size.height - keyboardEndFrame.height - newFrame.size.height :  self.view.frame.size.height - newFrame.size.height;
    inputView.frame = newFrame;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText),@"nickName":@"哈哈哈哈"};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture),@"nickName":@"哈哈哈哈"};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice),@"nickName":@"哈哈哈哈"};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}


- (void)dealloc
{
    [self.refreshHeaderView free];
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
