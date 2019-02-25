//
//  LHDatePicker.m
//  PetFriend
//
//  Created by liuhao on 2019/1/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "PFDatePicker.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CONTENT_H 255
#define UPVIEW_H AUTO_FIT(40.0f)

@interface PFDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSInteger _yearRange;
    NSInteger _dayRange;
    NSInteger _startYear;
    NSInteger _selectedYear;
    NSInteger _selectedMonth;
    NSInteger _selectedDay;
    NSInteger _selectedHour;
    NSInteger _selectedMinute;
    NSInteger _selectedSecond;
    NSCalendar *_calendar;
    //左边退出按钮
    UIButton *_cancelButton;
    //右边的确定按钮
    UIButton *_chooseButton;
    UIView *_upVeiw;
    UIView *_splitView;
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleL;
/**
 * 模式
 */
@property (nonatomic, assign) PFDatePickerViewMode pickerViewMode;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, copy) void(^complete)(NSString *dateStr);

@end

@implementation PFDatePicker

+ (void)showWithDate:(NSDate *)date title:(NSString *)title mode:(PFDatePickerViewMode)mode complete:(void(^)(NSString *dateStr))complete {
    PFDatePicker *picker = [PFDatePicker new];
    if (date) {
        picker.currentDate = date;
    } else {
        picker.currentDate = [NSDate date];
    }
    picker.pickerViewMode = mode;
    picker.complete = complete;
    picker.titleL.text = title;
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    [picker showDateTimePickerView];
}

+ (void)showWithTitle:(NSString *)title mode:(PFDatePickerViewMode)mode complete:(void(^)(NSString *dateStr))complete {
    [self showWithDate:[NSDate date] title:title mode:mode complete:complete];
}

+ (void)showWitMode:(PFDatePickerViewMode)mode complete:(void(^)(NSString *dateStr))complete {
    [self showWithDate:[NSDate date] title:nil mode:mode complete:complete];
}

+ (void)showWithDate:(NSDate *)date complete:(void(^)(NSString *dateStr))complete {
    [self showWithDate:date title:nil mode:PFDatePickerViewDateTimeMode complete:complete];
}

+ (void)showWitComplete:(void(^)(NSString *dateStr))complete {
    [self showWithDate:[NSDate date] title:nil mode:PFDatePickerViewDateTimeMode complete:complete];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentVH = CONTENT_H - 5.0f;
    CGFloat pickerViewY = AUTO_FIT(40.0f);
    CGFloat itemMargin = AUTO_FIT(kGallopItemMargin);
    if (self.alpha) {
        _contentV.frame = CGRectMake(0, SCREEN_HEIGHT - contentVH, SCREEN_WIDTH, contentVH);
    } else {
        _contentV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, contentVH);
    }
    self.pickerView.frame = CGRectMake(0, pickerViewY, SCREEN_WIDTH, self.contentV.height - pickerViewY);
    
    _upVeiw.frame = CGRectMake(0, 0, SCREEN_WIDTH, pickerViewY);
    
    _cancelButton.frame = CGRectMake(itemMargin, 0, pickerViewY, pickerViewY);
    _chooseButton.frame = CGRectMake(SCREEN_WIDTH - pickerViewY - itemMargin, 0, pickerViewY, pickerViewY);
    
    _splitView.frame = CGRectMake(0, pickerViewY, SCREEN_WIDTH, 0.5);
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:.5f];
        self.alpha = 0;
        
        
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CONTENT_H)];
        contentV.backgroundColor = [UIColor whiteColor];
        contentV.layer.cornerRadius = 10;
        contentV.layer.masksToBounds = YES;
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, UPVIEW_H, SCREEN_WIDTH, self.contentV.height - UPVIEW_H)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        
        [contentV addSubview:self.pickerView];
        
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, UPVIEW_H)];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [contentV addSubview:upVeiw];
        _upVeiw = upVeiw;
        //左边的取消按钮
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(AUTO_FIT(kGallopItemMargin), 0, UPVIEW_H, UPVIEW_H);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont pf_fontWithName:@"PingFangSC-Medium" size:16];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(_cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:_cancelButton];
        
        //右边的确定按钮
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - UPVIEW_H - AUTO_FIT(kGallopItemMargin), 0, UPVIEW_H, UPVIEW_H);
        [_chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        [_chooseButton setTitleColor:COLOUR_YELLOW forState:UIControlStateNormal];
        _chooseButton.backgroundColor = [UIColor clearColor];
        _chooseButton.titleLabel.font = [UIFont pf_fontWithName:@"PingFangSC-Medium" size:16];        [_chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:_chooseButton];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cancelButton.frame), 0, SCREEN_WIDTH-AUTO_FIT(kGallopItemMargin * 2)-UPVIEW_H * 2, UPVIEW_H)];
        [upVeiw addSubview:_titleL];
        _titleL.textColor = COLOR_FONT_GREY;
        _titleL.font = FONT_SYSTEM_15;
        _titleL.textAlignment = NSTextAlignmentCenter;
        
        //分割线
//        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, UPVIEW_H, [UIScreen mainScreen].bounds.size.width, 0.5)];
//        splitView.backgroundColor = UIColorFromRGB(0xe6e6e6);
//        [upVeiw addSubview:splitView];
//        _splitView = splitView;
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
        _startYear=1900;
        _yearRange=year - 1900+1;
        [self setCurrentDate:[NSDate date]];
    }
    return self;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerViewMode == PFDatePickerViewDateTimeMode) {
        return 5;
    } else if (self.pickerViewMode == PFDatePickerViewDateMode) {
        return 3;
    } else if (self.pickerViewMode == PFDatePickerViewTimeMode) {
        return 2;
    }
    return 0;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerViewMode == PFDatePickerViewDateTimeMode) {
        switch (component) {
            case 0: {
                return _yearRange;
            }
                break;
            case 1: {
                return 12;
            }
                break;
            case 2: {
                return _dayRange;
            }
                break;
            case 3: {
                return 24;
            }
                break;
            case 4: {
                return 60;
            }
                break;
                
            default:
                break;
        }
    } else if (self.pickerViewMode == PFDatePickerViewDateMode) {
        switch (component) {
            case 0: {
                return _yearRange;
            }
                break;
            case 1: {
                return 12;
            }
                break;
            case 2: {
                return _dayRange;
            }
                break;
                
            default:
                break;
        }
    } else if (self.pickerViewMode == PFDatePickerViewTimeMode) {
        switch (component) {
            case 0: {
                return 24;
            }
                break;
            case 1: {
                return 60;
            }
                break;
            default:
                break;
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
// 默认时间的处理
- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:currentDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    _selectedYear=year;
    _selectedMonth=month;
    _selectedDay=day;
    _selectedHour=hour;
    _selectedMinute=minute;
    
    _dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == PFDatePickerViewDateTimeMode) {
        [self.pickerView selectRow:year-_startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-_startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
    } else if (self.pickerViewMode == PFDatePickerViewDateMode) {
        [self.pickerView selectRow:year-_startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-_startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    } else if (self.pickerViewMode == PFDatePickerViewTimeMode) {
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
    }
    [self.pickerView reloadAllComponents];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*component/6.0, 0,SCREEN_WIDTH/6.0, 30)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.tag = component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    if (self.pickerViewMode == PFDatePickerViewDateTimeMode) {
        switch (component) {
            case 0: {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(_startYear + row)];
            }
                break;
            case 1: {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2: {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3: {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4: {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5: {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    } else if (self.pickerViewMode == PFDatePickerViewDateMode) {
        switch (component) {
            case 0: {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(_startYear + row)];
            }
                break;
            case 1: {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2: {
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    } else if (self.pickerViewMode == PFDatePickerViewTimeMode) {
        switch (component) {
            case 0: {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 1: {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            default:
                break;
        }
    }
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerViewMode == PFDatePickerViewDateTimeMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    } else if (self.pickerViewMode == PFDatePickerViewDateMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    } else if (self.pickerViewMode == PFDatePickerViewTimeMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerViewMode == PFDatePickerViewDateTimeMode) {
        switch (component) {
            case 0: {
                _selectedYear=_startYear + row;
                _dayRange=[self isAllDay:_selectedYear andMonth:_selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1: {
                _selectedMonth=row+1;
                _dayRange=[self isAllDay:_selectedYear andMonth:_selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2: {
                _selectedDay=row+1;
            }
                break;
            case 3: {
                _selectedHour=row;
            }
                break;
            case 4: {
                _selectedMinute=row;
            }
                break;
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",_selectedYear,_selectedMonth,_selectedDay,_selectedHour,_selectedMinute];
    } else if (self.pickerViewMode == PFDatePickerViewDateMode) {
        switch (component) {
            case 0: {
                _selectedYear=_startYear + row;
                _dayRange=[self isAllDay:_selectedYear andMonth:_selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1: {
                _selectedMonth=row+1;
                _dayRange=[self isAllDay:_selectedYear andMonth:_selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2: {
                _selectedDay=row+1;
            }
                break;
            default:
                break;
        }
        
        _string = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",_selectedYear,_selectedMonth,_selectedDay];
    } else if (self.pickerViewMode == PFDatePickerViewTimeMode) {
        switch (component) {
            case 0: {
                _selectedHour=row;
            }
                break;
            case 1: {
                _selectedMinute=row;
            }
                break;
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld",_selectedHour,_selectedMinute];
    }
}



#pragma mark - show and hidden
- (void)showDateTimePickerView {
    [self setCurrentDate:_currentDate];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self layoutSubviews];
    lh_animations(^{
        self.alpha = 1;
        self->_contentV.frame = CGRectMake(0, SCREEN_HEIGHT-CONTENT_H, SCREEN_WIDTH, CONTENT_H);
    }, ^{
        
    });
}
- (void)hideDateTimePickerView {
    lh_animations(^{
        self.alpha = 0;
        self->_contentV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CONTENT_H);
    }, ^{
        [self removeFromSuperview];
    });
    
}
#pragma mark - private
//取消的隐藏
- (void)_cancelButtonClick {
    [self hideDateTimePickerView];
    
}

//确认的隐藏
- (void)configButtonClick {
    SAFE_BLOCK(self.complete, _string);
    
    [self hideDateTimePickerView];
}

- (NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month {
    int day=0;
    switch(month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2: {
            if(((year%4==0) &&
                (year%100!=0))||
               (year%400==0)) {
                day=29;
                break;
            } else {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideDateTimePickerView];
}

@end
