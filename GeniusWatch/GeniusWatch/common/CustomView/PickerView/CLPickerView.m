//
//  CLPickerView.m
//  XSHCar
//
//  Created by clei on 14/12/23.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CLPickerView.h"

typedef void (^SureBlock) (UIDatePicker *datePicker, NSDate *date);
typedef void (^CustomSureBlock) (UIPickerView *datePicker, int index);
typedef void (^CancelBlock) ();

@interface CLPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
}
@property(nonatomic, assign) PickerViewType pickerType;
@property(nonatomic, copy) SureBlock sureBlock;
@property(nonatomic, copy) CancelBlock cancelBlock;
@property(nonatomic, copy) CustomSureBlock custonSureBlock;
@end

@implementation CLPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)type sureBlock:(void (^)(UIDatePicker *datePicker,NSDate *date))sure cancelBlock:(void (^)())cancel
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.pickerType = type;
        self.cancelBlock = cancel;
        self.sureBlock = sure;
        [self createUIWithPickerViewType:type];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)type customSureBlock:(void (^)(UIPickerView *pickView, int index))customSure cancelBlock:(void (^)())customCancel pickerData:(NSArray *)array
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.pickerType = type;
        self.cancelBlock = customCancel;
        self.custonSureBlock = customSure;
        self.dataArray = array;
        [self createUIWithPickerViewType:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

#pragma mark 初始化UI
- (void)createUIWithPickerViewType:(PickerViewType)type
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:Nil];
    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(sure)];
    toolBar.items = @[cancelItem,spaceItem,sureItem];
    [self addSubview:toolBar];
    
    if (PickerViewTypeDate == type)
    {
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height,self.frame.size.width, self.frame.size.height - toolBar.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:datePicker];
    }
    else if (PickerViewTypeTime == type)
    {
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height,self.frame.size.width, self.frame.size.height - toolBar.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self addSubview:datePicker];
    }
    else if (PickerViewTypeCustom == type)
    {
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height,self.frame.size.width, self.frame.size.height - toolBar.frame.size.height)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
    }
}

- (void)setPickViewMaxDate
{
    datePicker.maximumDate = [NSDate date];
}

- (void)setPickViewMinDate
{
    datePicker.minimumDate = [NSDate date];
}

#pragma mark pickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [self.dataArray count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (void)cancel
{
    if (self.cancelBlock)
    {
        self.cancelBlock();
    }
}

- (void)sure
{
    if (PickerViewTypeDate == self.pickerType || PickerViewTypeTime == self.pickerType)
    {
        //datePicker.date;
        if (self.sureBlock)
        {
            self.sureBlock(datePicker,datePicker.date);
        }
    }
    if (PickerViewTypeCustom == self.pickerType)
    {
        if (self.custonSureBlock)
        {
            self.custonSureBlock(pickerView,(int)[pickerView selectedRowInComponent:0]);
        }
    }
}

- (void)dealloc
{
    self.sureBlock = nil;
    self.cancelBlock = nil;
    self.custonSureBlock = nil;
}



@end
