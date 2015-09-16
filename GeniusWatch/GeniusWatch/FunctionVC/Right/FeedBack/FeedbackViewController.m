//
//  FeedbackViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "FeedbackViewController.h"

#define SPACE_X             5.0
#define SPACE_Y             10.0
#define TEXTVIEW_HEIGHT     150.0 * CURRENT_SCALE
#define LABLE_HEIGHT        15.0
#define PLACEHOLDER_TEXT    @"请在这里输入文字..."


@interface FeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *countLabel;

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
    
}

- (void)addButton
{
    
}

#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden =YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 400)
        [CommonTool addAlertTipWithMessage:@"文字长度不能超过400"];
    textView.text = (textView.text.length > 400) ? [textView.text stringByReplacingCharactersInRange:NSMakeRange(400, 1) withString:@""] : textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView
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
