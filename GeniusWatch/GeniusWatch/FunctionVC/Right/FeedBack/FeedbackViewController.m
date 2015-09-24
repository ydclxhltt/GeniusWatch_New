//
//  FeedbackViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AddPicView.h"
#import "UpLoadPhotoTool.h"

#define SPACE_X             5.0
#define SPACE_Y             10.0
#define TEXTVIEW_HEIGHT     150.0 * CURRENT_SCALE
#define LABLE_HEIGHT        15.0
#define PLACEHOLDER_TEXT    @"请在这里输入文字..."
#define INPUT_WORD_MAX      @"400"
#define ADDPICVIEW_HEIGHT   100.0 * CURRENT_SCALE
#define ADDPIC_MAX          3
#define BUTTON_ADD_Y        40.0
#define BUTTON_SPACE_X      30.0 * CURRENT_SCALE

//意见反馈
#define LOADING             @"正在反馈..."
#define LOADING_SUCESS      @"反馈成功"
#define LOADING_FAIL        @"反馈失败"


@interface FeedbackViewController ()<UITextViewDelegate,UploadPhotoDelegate>

@property (nonatomic, strong) AddPicView *addPicView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTextView];
    [self addImageViews];
    [self addButton];
}

- (void)addTextView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TEXTVIEW_HEIGHT)];
    _textView.textColor = [UIColor blackColor];
    _textView.font = FONT(14.0);
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    // _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    _textView.text = @"";
    [self.view addSubview:_textView];
    
    
    _placeholderLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, _textView.frame.size.width, LABLE_HEIGHT) textString:PLACEHOLDER_TEXT textColor:TIP_COLOR textFont:TIP_FONT];
    //_placeholderLabel.font = [UIFont fontWithName:@"Arial" size:13.0];//设置字体名字和字体大小
    [_textView addSubview:_placeholderLabel];
    
    start_y = _textView.frame.origin.y + _textView.frame.size.height;
    
    _countLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, start_y,  _textView.frame.size.width, LABLE_HEIGHT) textString:@"400" textColor:TIP_COLOR textFont:TIP_FONT];
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_countLabel];
    
    start_y += _countLabel.frame.size.height;
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, 0.5) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
    
    start_y += lineImageView.frame.size.height;

}

- (void)addImageViews
{
    _addPicView = [[AddPicView alloc] initWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, ADDPICVIEW_HEIGHT) maxPicCount:ADDPIC_MAX superViewController:self];
    [self.view addSubview:_addPicView];
    
    start_y += _addPicView.frame.size.height;
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, start_y, self.view.frame.size.width, 0.5) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
    
    start_y += lineImageView.frame.size.height + BUTTON_ADD_Y;
}

- (void)addButton
{
    _sendButton = [CreateViewTool createButtonWithFrame:CGRectMake(BUTTON_SPACE_X, start_y, self.view.frame.size.width - 2 * BUTTON_SPACE_X, BUTTON_HEIGHT) buttonTitle:@"发送" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"sendButtonPressed:" tagDelegate:self];
    _sendButton.titleLabel.font = BUTTON_FONT;
    [CommonTool clipView:_sendButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:_sendButton];
}


#pragma mark 发送
- (void)sendButtonPressed:(UIButton *)sender
{
    NSDictionary *dic = @{@"reqContent":self.textView.text};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [SVProgressHUD showWithStatus:LOADING];
    UpLoadPhotoTool *updatePhotoTool = [[UpLoadPhotoTool alloc] initWithPhotoArray:self.addPicView.dataArray upLoadUrl:FEEDBACK_URL requestData:@{@"arJsonData":jsonString}];
    updatePhotoTool.delegate = self;
}

#pragma mark UploadPhotoDelegate
- (void)uploadPhotoSucessed:(UpLoadPhotoTool *)upLoadPhotoTool
{
    [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
}

- (void)uploadPhotoFailed:(UpLoadPhotoTool *)upLoadPhotoTool
{
    [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
}

- (void)uploadPhoto:(UpLoadPhotoTool *)upLoadPhotoTool isUploadedPhotoProcess:(float)process
{
    
}

#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden =YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.sendButton.enabled = (textView.text.length > 0) ? YES : NO;
    
    if (textView.text.length > [INPUT_WORD_MAX intValue])
    {
         [CommonTool addAlertTipWithMessage:[NSString stringWithFormat:@"%@%@",@"文字长度不能超过",INPUT_WORD_MAX]];
    }

    textView.text = [textView.text substringToIndex:(textView.text.length > [INPUT_WORD_MAX intValue]) ? 400 : (int)textView.text.length];
    self.countLabel.text = [NSString stringWithFormat:@"%d",[INPUT_WORD_MAX intValue] - (int)textView.text.length];
}

- (void)textViewDidEndEditing:(UITextView *)textView2
{
    
    if (self.textView.text.length==0)
    {
        self.placeholderLabel.hidden =NO;
    }
    else
    {
        self.placeholderLabel.hidden =YES;
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
