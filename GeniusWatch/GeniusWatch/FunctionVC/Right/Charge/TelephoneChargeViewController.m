//
//  TelephoneChargeViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#define IMAGEVIEW_HEIGHT   55.0
#define ADD_X              10.0 * CURRENT_SCALE

#import "TelephoneChargeViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

@interface TelephoneChargeViewController ()<UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) MJRefreshHeaderView *refreshHeaderView;
@property (strong, nonatomic) ChatModel *chatModel;
@property (strong, nonatomic) UITableView *chatTableView;

@end

@implementation TelephoneChargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)initUI
{
    [self addButtons];
    [self addTableView];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
}


- (void)addButtons
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - IMAGEVIEW_HEIGHT, self.view.frame.size.width, IMAGEVIEW_HEIGHT) placeholderImage:nil];
    imageView.backgroundColor = APP_MAIN_COLOR;
    [self.view addSubview:imageView];
    
    float line_space_y = 5.0;
    float line_width = 1.0;
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(imageView.frame.size.width/2 - line_width/2, line_space_y, line_width, imageView.frame.size.height - 2 * line_space_y) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:lineImageView];
    
  
    float button_width = imageView.frame.size.width/2;
    float button_height = imageView.frame.size.height;
    NSArray *titleArray = @[@"查流量",@"查话费"];
    NSArray *imageArray = @[@"charge_stream",@"charge_pay"];

    
    for (int i = 0; i < [titleArray count]; i++)
    {
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        float image_height = image.size.height/3 * CURRENT_SCALE;
        float image_width = image.size.width/3 * CURRENT_SCALE;
        float title_width = [titleArray[i] sizeWithAttributes:@{NSFontAttributeName : BUTTON_FONT}].width;
        float space_x = (button_width - ADD_X - image_width - title_width)/2;
        float space_y = (button_height - image_height)/2;
        
        UIImageView *iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(space_x + i * button_width, space_y, image_width, image_height) placeholderImage:image borderColor:nil imageUrl:nil];
        [imageView addSubview:iconImageView];
        
        UILabel *titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + ADD_X , 0, title_width, button_height) textString:titleArray[i] textColor:BUTTON_TITLE_COLOR textFont:BUTTON_FONT];
        [imageView addSubview:titleLabel];
        
        UIButton *button = [CreateViewTool  createButtonWithFrame:CGRectMake(i * button_width, 0, button_width, button_height) buttonTitle:nil titleColor:nil normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"chargeButtonPressed:" tagDelegate:self];
        button.showsTouchWhenHighlighted = YES;
        [imageView addSubview:button];
    }
}

//添加表格
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - IMAGEVIEW_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
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
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}


//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark 按钮响应时间
- (void)chargeButtonPressed:(UIButton *)sender
{
    
}


//#pragma mark - InputFunctionViewDelegate
//- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
//{
//    NSDictionary *dic = @{@"strContent": message,
//                          @"type": @(UUMessageTypeText)};
//    funcView.TextViewInput.text = @"";
//    [funcView changeSendBtnWithPhoto:YES];
//    [self dealTheFunctionData:dic];
//}
//
//- (void)dealTheFunctionData:(NSDictionary *)dic
//{
//    [self.chatModel addSpecifiedItem:dic];
//    [self.chatTableView reloadData];
//    [self tableViewScrollToBottom];
//}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
