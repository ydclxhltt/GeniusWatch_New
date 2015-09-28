//
//  SetPhoneNumberViewController.m
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/20.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetLinkNumberViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define TIPLABLE_SPACE_Y    NAVBAR_HEIGHT + 10.0 * CURRENT_SCALE
#define TIPLABLE_HEIGHT     25.0
#define SPACE_X             20.0 * CURRENT_SCALE
#define ADD_Y               10.0
#define BUTTON_ADD_Y        40.0

//更新联系人信息
#define LOADING             @"添加中..."
#define LOADING_SUCESS      @"添加成功"
#define LOADING_FAIL        @"添加失败"

@interface SetLinkNumberViewController ()<ABPeoplePickerNavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSString *shortNumberStr;
@property (nonatomic, strong) NSString *phoneNumberStr;

@end

@implementation SetLinkNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人号码";
    [self addBackItem];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTipLabel];
    [self addTextFields];
    [self addButton];
}

- (void)addTipLabel
{
    UILabel *tipLable = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, TIPLABLE_SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, TIPLABLE_HEIGHT) textString:self.linkmanStr textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [self.view addSubview:tipLable];
    
    start_y = tipLable.frame.size.height + tipLable.frame.origin.y + ADD_Y;
}

- (void)addTextFields
{
    float space_x = 5.0;
    float space_y = 5.0;
    UIImage *image = [UIImage imageNamed:@"linkbook_up"];
    float width = image.size.width/3;
    float height = image.size.height/3;
    
    UITextField *phoneNumberTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"联系人电话号码"];
    [CommonTool clipView:phoneNumberTextField withCornerRadius:TEXTFIELD_RADIUS];
    [CommonTool setViewLayer:phoneNumberTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    phoneNumberTextField.tag = 100;
    phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNumberTextField];
    
    UIImageView *imageView1 = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, width + 2 * space_x, height + 2 * space_y) placeholderImage:nil];
    UIButton *contactbutton1 = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, space_y, width, height) buttonImage:@"linkbook" selectorName:@"linkbookButtonPressed:" tagDelegate:self];
    contactbutton1.tag = 1;
    [imageView1 addSubview:contactbutton1];
    phoneNumberTextField.rightView = imageView1;
    phoneNumberTextField.rightViewMode = UITextFieldViewModeAlways;
    
    start_y += phoneNumberTextField.frame.size.height +  ADD_Y;
    UITextField *shortTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:TEXTFIELD_FONT placeholderText:@"亲情号码/短号"];
    [CommonTool clipView:shortTextField withCornerRadius:TEXTFIELD_RADIUS];
    [CommonTool setViewLayer:shortTextField withLayerColor:TEXTFIELD_COLOR bordWidth:.5];
    shortTextField.tag = 101;
    shortTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:shortTextField];
    
    UIImageView *imageView2 = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, width + 2 * space_x, height + 2 * space_y) placeholderImage:nil];
    UIButton *contactbutton2 = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, space_y, width, height) buttonImage:@"linkbook" selectorName:@"linkbookButtonPressed:" tagDelegate:self];
    contactbutton2.tag = 2;
    [imageView2 addSubview:contactbutton2];
    shortTextField.rightView = imageView2;
    shortTextField.rightViewMode = UITextFieldViewModeAlways;

    start_y += shortTextField.frame.size.height + BUTTON_ADD_Y;
}


- (void)addButton
{
    UIButton *saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, start_y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"保存" titleColor:BUTTON_TITLE_COLOR normalBackgroundColor:BUTTON_N_COLOR highlightedBackgroundColor:BUTTON_H_COLOR selectorName:@"saveButtonPressed:" tagDelegate:self];
    [CommonTool clipView:saveButton withCornerRadius:BUTTON_RADIUS];
    [self.view addSubview:saveButton];
}


#pragma mark 通讯录按钮
- (void)linkbookButtonPressed:(UIButton *)sender
{
    self.selectedIndex = (int)sender.tag - 1;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate
- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self makeDataWithPerson:person];
    return YES;
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self makeDataWithPerson:person];
}

- (void)makeDataWithPerson:(ABRecordRef)person
{
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray *array = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumbers);
    if ([array count] == 0)
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:100 + self.selectedIndex];
        textField.text = [array[0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    else if([array count] > 1)
    {
        [self showActionSheetWithArray:array];
    }
}

- (void)showActionSheetWithArray:(NSArray *)array
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择电话号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSString *string in array)
    {
        [actionSheet addButtonWithTitle:[string  stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        return;
    }
    UITextField *textField = (UITextField *)[self.view viewWithTag:100 + self.selectedIndex];
    textField.text = [actionSheet buttonTitleAtIndex:buttonIndex];
}


#pragma mark 保存
- (void)saveButtonPressed:(UIButton *)sender
{
    if (![self isCanCommit])
    {
        return;
    }
    [self addLinkman];
}

- (BOOL)isCanCommit
{
    NSString *phoneString = ((UITextField *)[self.view viewWithTag:100]).text;
    phoneString = phoneString ? phoneString : @"";
    NSString *shortString = ((UITextField *)[self.view viewWithTag:101]).text;
    shortString = shortString ? shortString : @"";
    NSString *message = @"";
    if (phoneString.length == 0)
    {
        message = @"号码不能为空";
    }
    else if (shortString.length == 0)
    {
        message = @"短号码不能为空";
    }
    else if (![CommonTool isEmailOrPhoneNumber:phoneString])
    {
        message = @"手机号码不正确";
    }
    if (message.length != 0)
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    self.phoneNumberStr = phoneString;
    self.shortNumberStr = shortString;
    return YES;
}

- (void)addLinkman
{
    //__weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING];
    NSString *imeiNo = [GeniusWatchApplication shareApplication].currentDeviceDic[@"imeiNo"];
    imeiNo = (imeiNo) ? imeiNo : @"";
    NSDictionary *requestDic = @{@"imeiNo":imeiNo,@"binder":[GeniusWatchApplication shareApplication].userName,@"contact":@{@"nickName":self.linkmanStr,@"mobileNo":self.phoneNumberStr,@"shortPhoneNo":self.shortNumberStr,@"userType":@"3"}};
    [[RequestTool alloc] requestWithUrl:ADD_CONTACTS_URL
                            requestParamas:requestDic
                               requestType:RequestTypeAsynchronous
                             requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_LOCATION_URL===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         NSString *errorCode = dic[@"errorCode"];
         NSString *description = dic[@"description"];
         description = (description) ? description : LOADING_FAIL;
         if ([@"0" isEqualToString:errorCode])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContact" object:nil];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:description];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UPDATE_LOCATION_error====%@",error);
         //[SVProgressHUD showErrorWithStatus:LOADING_FAIL];
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
