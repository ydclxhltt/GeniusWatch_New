//
//  AddLinkManViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/20.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddLinkManViewController.h"
#import "SetLinkNumberViewController.h"

#define SPACE_Y             20.0 * CURRENT_SCALE
#define IMAGE_VIEW_HW       100.0 * CURRENT_SCALE
#define ADD_Y               10.0 
#define LABEL_HEIGHT        30.0 * CURRENT_SCALE
#define LABLE_WIDTH         IMAGE_VIEW_HW
//更新联系人信息
#define LOADING             @"更新中..."
#define LOADING_SUCESS      @"更新成功"
#define LOADING_FAIL        @"更新失败"

@interface AddLinkManViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation AddLinkManViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑关系和名称";
    [self addBackItem];
    NSString *title = (self.pushFor == PushForAdd) ? @"   下一步" : @"    完成";
    [self setNavBarItemWithTitle:title navItemType:RightItem selectorName:@"nextButtonPressed:"];
    
    self.imagesArray = [GeniusWatchApplication shareApplication].imagesArray;
    self.titlesArray = [GeniusWatchApplication shareApplication].titlesArray;
    self.selectedIndex = -1;
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark  初始化UI
- (void)initUI
{
    [self addScrollView];
    [self addTextField];
}

- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _showButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) buttonImage:@"" selectorName:@"showButtonPressed:" tagDelegate:self];
    [_scrollView addSubview:_showButton];
    
    float totleHeight = _scrollView.frame.size.height;
    float space_x = (_scrollView.frame.size.width - 2 * IMAGE_VIEW_HW) / 3;
    float row = ceil([self.imagesArray count]/2.0);
    for (int i = 0; i < row; i++)
    {
        float m = 2;
        if (i == row - 1)
        {
            m = ([self.imagesArray count]%2 == 0) ? 2 : [self.imagesArray count]%2;
        }
        
        for (int j = 0; j < m; j++)
        {
            int index = i * 2 + j;
            float x = space_x + j * (space_x + IMAGE_VIEW_HW);
            float y = SPACE_Y + (IMAGE_VIEW_HW + LABEL_HEIGHT + ADD_Y) * i;
            UIImageView *imageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(x, y, IMAGE_VIEW_HW, IMAGE_VIEW_HW) placeholderImage:[UIImage imageNamed:self.imagesArray[index]] borderColor:nil imageUrl:@""];
            imageView.tag = index + 1;
            [_scrollView addSubview:imageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
            [imageView addGestureRecognizer:tapGesture];
            
            
            float label_y = imageView.frame.origin.y + imageView.frame.size.height;
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(imageView.frame.origin.x, label_y, imageView.frame.size.width, LABEL_HEIGHT) textString:self.titlesArray[index] textColor:[UIColor blackColor] textFont:FONT(15.0)];
            label.tag = 100 + index;
            label.textAlignment = NSTextAlignmentCenter;
            [_scrollView addSubview:label];
            
            totleHeight = label_y + SPACE_Y + label.frame.size.height;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, totleHeight);
}

- (void)addTextField
{
    _nameTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"请输入自定义名字"];
    [CommonTool setViewLayer:_nameTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    _nameTextField.delegate = self;
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.text = @"";
    [self.view addSubview:_nameTextField];
}

#pragma mark 显示隐藏
- (void)showButtonPressed:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
}

#pragma mark 图像点击事件
- (void)imageViewPressed:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)[tapGesture view];
    if (!self.selectedImageView)
    {
        _selectedImageView = [CreateViewTool  createImageViewWithFrame:imageView.frame placeholderImage:[UIImage imageNamed:@"address_book_circle"]];
        [self.scrollView insertSubview:_selectedImageView atIndex:0];
    }
    
    _selectedImageView.frame = imageView.frame;
    self.selectedIndex = (int)imageView.tag - 1;
    if (self.selectedIndex == [self.imagesArray count] - 1)
    {
        _selectedImageView.hidden = (self.nameTextField.text.length == 0);
        [self.nameTextField becomeFirstResponder];
    }
    else
    {
        _selectedImageView.hidden = NO;
        [self.nameTextField resignFirstResponder];
    }
    
}

#pragma mark 下一步
- (void)nextButtonPressed:(UIButton *)sender
{
    if ((self.nameTextField.text.length == 0 && self.selectedIndex == [self.titlesArray count] - 1)|| self.selectedIndex == -1)
    {
        [CommonTool addAlertTipWithMessage:@"用户名不能为空"];
        return;
    }
    if (self.pushFor == PushForAdd)
    {
        SetLinkNumberViewController *setLinkNumberViewController = [[SetLinkNumberViewController alloc] init];
        setLinkNumberViewController.linkmanStr =  (self.selectedIndex != [self.titlesArray count] - 1) ? self.titlesArray[self.selectedIndex] : self.nameTextField.text;
        [self.navigationController pushViewController:setLinkNumberViewController animated:YES];
        
    }
    else
    {
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
        NSString *nickName =  (self.selectedIndex != [self.titlesArray count] - 1) ? self.titlesArray[self.selectedIndex] : self.nameTextField.text;
        [dataDic setValue:nickName forKey:@"nickName"];
        [self changeOwnerInfoWithDataDic:dataDic];
    }
}

#pragma mark 修改通讯录
- (void)changeOwnerInfoWithDataDic:(NSMutableDictionary *)dataDic
{
    
    [SVProgressHUD showWithStatus:LOADING];
    NSString *binder = [GeniusWatchApplication shareApplication].userName;
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"contact":dataDic,@"binder":binder};
   // __weak typeof(self) weakSelf = self;
    [[RequestTool alloc] requestWithUrl:UPDATE_CONTACT_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_CONTACT_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             //[weakSelf.navigationController popViewControllerAnimated:YES];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContact" object:nil];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_CONTACT_URL_error====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
}

#pragma mark 文本变化
- (void)textFieldTextDidChanged:(NSNotification *)notification
{
    _selectedImageView.hidden = (self.nameTextField.text.length == 0);
    UILabel *lable = (UILabel *)[self.scrollView viewWithTag:(100 + self.selectedIndex)];
    lable.text = (self.nameTextField.text.length == 0) ? self.titlesArray[self.selectedIndex] : self.nameTextField.text;
}

#pragma mark 键盘通知
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    CGRect newFrame = self.nameTextField.frame;
    float y = (notification.name == UIKeyboardWillShowNotification) ? keyboardEndFrame.origin.y - newFrame.size.height : self.view.frame.size.height;
    newFrame.origin.y = y;
    self.nameTextField.frame = newFrame;
    [UIView commitAnimations];
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
