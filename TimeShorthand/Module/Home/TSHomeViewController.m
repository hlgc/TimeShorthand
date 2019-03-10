//
//  TSHomeViewController.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSHomeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "XLClock.h"
#import "TSHomeDateView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TSShareView.h"
#import "TSDateTool.h"
#import "TSEventListController.h"
#import "TSEventModel.h"
#import "TSTargetController.h"

@interface TSHomeViewController ()

@property (nonatomic, strong) XLClock *clock;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, copy) NSArray <TSHomeDateView *>*dates;

@property (nonatomic, strong) UILabel *bottomTipLabel;
@property (nonatomic, strong) UIView *bottomLine;

/// 能做什么事
@property (nonatomic, copy) NSArray <UIButton *>*events;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *dateTimer;

///事件
@property (nonatomic, strong) NSMutableArray *eventDatas;
@property (nonatomic, copy) NSString *fileName;

@end

@implementation TSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat clockW = 200.0f / 375.0f * self.view.width;
    _clock = [[XLClock alloc] initWithFrame:CGRectMake(0.0f, 20.0f, clockW, clockW)];
    _clock.centerX = self.view.centerX;
    [self.view addSubview:_clock];
    [_clock showStartAnimation];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = [NSString stringWithFormat:@"“%@”", TSUserTool.sharedInstance.user.name];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont pf_PingFangSC_RegularWithSize:18.0f];
    [self.view addSubview:_nameLabel];
    
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:TSUserTool.sharedInstance.user.birthday.integerValue]];
    NSTimeInterval dateDiff = [[df dateFromString:dateStr] timeIntervalSinceNow];
    double age = fabs(dateDiff/(60*60*24))/365;
    NSLog(@"年龄是:%@",[NSString stringWithFormat:@"%.10f岁",age]);
    
    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(dateStr.length-2, 2)];
    NSLog(@"出生于%@年%@月%@日", year, month, day);
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *compomemts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger nowYear = compomemts.year;
    NSInteger nowMonth = compomemts.month;
    NSInteger nowDay = compomemts.day;
    NSLog(@"今天是%ld年%ld月%ld日", nowYear, nowMonth, nowDay);
    
    // 计算年龄
    NSInteger userAge = nowYear - year.intValue - 1;
    if ((nowMonth > month.intValue) || (nowMonth == month.intValue && nowDay >= day.intValue)) {
        userAge++;
    }
    NSLog(@"用户年龄是%ld",userAge);
    
    _ageButton = [UILabel new];
    _ageButton.text = [NSString stringWithFormat:@"You are %.10f years old.",age];
    _ageButton.textColor = [UIColor blackColor];
    _ageButton.font = [UIFont pf_PingFangSC_RegularWithSize:18.0f];
    [self.view addSubview:_ageButton];
    
    _tipLabel = [UILabel new];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"In this world, you already exist:";
    _tipLabel.textColor = [UIColor blackColor];
    _tipLabel.font = [UIFont pf_PingFangSC_LightWithSize:14.0f];
    [self.view addSubview:_tipLabel];
    
    _topLine = [UIView new];
    _topLine.backgroundColor = COLOR_LINE_GREY;
    [self.view addSubview:_topLine];
    
    _bottomTipLabel = [UILabel new];
    _bottomTipLabel.textAlignment = NSTextAlignmentCenter;
    _bottomTipLabel.text = @"In the rest of the time, you can still do it:";
    _bottomTipLabel.textColor = [UIColor blackColor];
    _bottomTipLabel.font = [UIFont pf_PingFangSC_LightWithSize:14.0f];
    [self.view addSubview:_bottomTipLabel];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = COLOR_LINE_GREY;
    [self.view addSubview:_bottomLine];
    
    [self timer];
    [self dateTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _ageButton.size = _nameLabel.size = CGSizeMake(self.view.width - 60.0f, 20.0f);
    _ageButton.left = _nameLabel.left = 30.0f;
    _nameLabel.top = _clock.bottom + 20.0f;
    
    _ageButton.top = _nameLabel.bottom + 10.0f;
    
    _tipLabel.size = CGSizeMake(_ageButton.width, 14.0f);
    _tipLabel.centerX = self.view.centerX;
    _tipLabel.top = _ageButton.bottom + 20.0f;
    
    _topLine.size = CGSizeMake(self.view.width - 40, .5f);
    _topLine.left = 20.0f;
    _topLine.top = _tipLabel.bottom + 10.0f;
    
    __block NSInteger c = 0;
    __block NSInteger row = 0;
    __block UIView *lastView = nil;
    [self.dates enumerateObjectsUsingBlock:^(TSHomeDateView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (c == 3) {
            row++;
            c = 0;
        }
        if (lastView && c) {
            obj.left = lastView.right;
        } else {
            obj.left = 20.0f;
        }
        obj.top = self.topLine.bottom + 10 + row * obj.height;
        c++;
        lastView = obj;
    }];
    
    _bottomTipLabel.size = CGSizeMake(_ageButton.width, 14.0f);
    _bottomTipLabel.centerX = self.view.centerX;
    _bottomTipLabel.top = lastView.bottom + 20.0f;
    
    _bottomLine.size = CGSizeMake(self.view.width - 40, .5f);
    _bottomLine.left = 20.0f;
    _bottomLine.top = _bottomTipLabel.bottom + 10.0f;
    
    c = 0;
    row = 0;
    lastView = nil;
    [self.events enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (c == 2) {
            row++;
            c = 0;
        }
        if (lastView && c) {
            obj.left = lastView.right;
        } else {
            obj.left = 20.0f;
        }
        obj.top = self.bottomLine.bottom + 10 + row * obj.height;
        c++;
        lastView = obj;
    }];
}

- (void)setupInit {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchMenu)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"target"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchTarget)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchShare)]];
}

- (void)onTouchMenu {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)onTouchTarget {
    TSTargetController *target = [TSTargetController new];
    [self.navigationController pushViewController:target animated:YES];
}

- (void)onTouchShare {
    [TSShareView showWithComplete:^(YKShareType type) {
        if (type == YKShareType_Copy) {
            [self savePhotoToAlbum];
            return ;
        }
        [TSShareTool shareImageToPlatformType:type shareImage:[self createShareImage]];
    }];
}

/// 点击事件
- (void)onTouchDateView:(UIButton *)button {
    TSEventListController *listVC = [TSEventListController new];
    listVC.s_model = [self.eventDatas objectAtIndex:button.tag];
    listVC.didCompleteBlcok = ^(TSEventModel *model) {
        __block TSEventModel *smodel = nil;
        [self.eventDatas enumerateObjectsUsingBlock:^(TSEventModel *modelobj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([modelobj.name isEqualToString:model.name]) {
                smodel = modelobj;
            }
        }];
        if (smodel) {
            [self.eventDatas removeObject:smodel];
        }
        [self.eventDatas insertObject:model atIndex:0];
        if (self.eventDatas.count > 4) {
            [self.eventDatas removeLastObject];
        }
        [[self.eventDatas modelToJSONObject] writeToFile:self.fileName atomically:NO];
        
        [self.events enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitle:((TSEventModel *)self.eventDatas[idx]).name forState:UIControlStateNormal];
            [obj pf_layoutButtonWithEdgeInsetsStyle:PFButtonEdgeInsetsStyleRight imageTitleSpace:.0f];
        }];
    };
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - Private
- (void)setInfo {
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:TSUserTool.sharedInstance.user.birthday.integerValue]];
    NSTimeInterval dateDiff = [[df dateFromString:dateStr] timeIntervalSinceNow];
    double age = fabs(dateDiff / (60 * 60 * 24)) / 365;
    _ageButton.text = [NSString stringWithFormat:@"You are %.10f years old.",age];
}

- (void)setDate {
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:TSUserTool.sharedInstance.user.birthday.integerValue]];
    NSTimeInterval dateDiff = [[df dateFromString:dateStr] timeIntervalSinceNow];
    NSInteger age = fabs(dateDiff / (60 * 60 * 24)) / 365;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - TSUserTool.sharedInstance.user.birthday.doubleValue;
    [self.dates enumerateObjectsUsingBlock:^(TSHomeDateView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                obj.titleLabel.text = [NSString stringWithFormat:@"%ld", ABS(age)];
                break;
            case 1:
                obj.titleLabel.text = [NSString stringWithFormat:@"%.0f", ABS(time / 60 / 60 / 24 / 30)];
                break;
            case 2:
                obj.titleLabel.text = [NSString stringWithFormat:@"%.0f", ABS(time / 60 / 60 / 24 / 7)];
                break;
            case 3:
                obj.titleLabel.text = [NSString stringWithFormat:@"%.0f", ABS(time / 60 / 60 / 24)];
                break;
            case 4:
                obj.titleLabel.text = [NSString stringWithFormat:@"%.0f", ABS(time / 60 / 60)];
                break;
            case 5:
                obj.titleLabel.text = [NSString stringWithFormat:@"%.0f", ABS(time / 60)];
                break;
            default:
                break;
        }
    }];
}

- (void)savePhotoToAlbum {
    //保存图片到本地
    [LHHudTool showLoadingWithMessage:@"Saving"];
    [TSTools savePhotoToCustomAlbumWithName:@"TimeShorthand" photo:[self createShareImage] saveBlock:^(int code, NSString *message) {
        [LHHudTool hideHUD];
        if (code == 200) {
            [LHHudTool showSuccessWithMessage:message];
        } else {
            [LHHudTool showErrorWithMessage:message];
        }
    }];
}

- (UIImage *)createShareImage {
    return [self.view.layer snapshotImage];
}

#pragma mark - Getter
- (NSArray <TSHomeDateView *>*)dates {
    if (_dates) {
        return _dates;
    }
    CGFloat W = (ScreenWidth - 40) / 3;
    CGFloat H = W * .45f;
    NSArray *tempDatas = @[@"Year",@"Month",@"Week",@"Day",@"Hour",@"Minute"];
    NSMutableArray *tempDates = @[].mutableCopy;
    [tempDatas enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
        TSHomeDateView *dateView = [TSHomeDateView new];
        [dateView setTitle:@"1982378" subTitle:string];
        dateView.size = CGSizeMake(W, H);
        [self.view addSubview:dateView];
        [tempDates addObject:dateView];
    }];
    _dates = tempDates.copy;
    return _dates;
}

- (NSArray <UIButton *>*)events {
    if (_events) {
        return _events;
    }
    CGFloat W = (ScreenWidth - 40) / 2;
    _fileName = [[TSTools getCurrentUserCacheFolderWithFolderName:@"events"] stringByAppendingString:@"/homeEventArr.plist"];
    NSArray *homeEventArr = [NSArray arrayWithContentsOfFile:_fileName];
    if (!homeEventArr) {
        NSInteger count = TSUserTool.sharedInstance.user.surplusLife;
        TSEventModel *model1 = [TSEventModel new];
        model1.day = 1;
        model1.name = [NSString stringWithFormat:@"Sleep %zd times", count / model1.day];
        
        TSEventModel *model2 = [TSEventModel new];
        model2.day = 1;
        model2.name = [NSString stringWithFormat:@"Bathe %zd times", count / model2.day];
        
        TSEventModel *model3 = [TSEventModel new];
        model3.day = 180;
        model3.name = [NSString stringWithFormat:@"Travel %ld times", count / model3.day];
        
        TSEventModel *model4 = [TSEventModel new];
        model4.day = 1;
        model4.name = [NSString stringWithFormat:@"ReadBook %zd times", count / model4.day];
        
        homeEventArr = @[[model1 modelToJSONObject], [model2 modelToJSONObject], [model3 modelToJSONObject], [model4 modelToJSONObject]];
        [homeEventArr writeToFile:_fileName atomically:NO];
    }
    
    NSArray *tempDatas = [NSArray modelArrayWithClass:TSEventModel.class json:homeEventArr];
    self.eventDatas = tempDatas.mutableCopy;
    NSMutableArray *tempDates = @[].mutableCopy;
    [tempDatas enumerateObjectsUsingBlock:^(TSEventModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *dateView = [UIButton new];
        dateView.tag = idx;
        dateView.titleLabel.font = [UIFont pf_PingFangSC_LightWithSize:14.0f];
        [dateView setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
        [dateView setTitle:model.name forState:UIControlStateNormal];
        [dateView setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [dateView addTarget:self action:@selector(onTouchDateView:) forControlEvents:UIControlEventTouchUpInside];
        dateView.size = CGSizeMake(W, 30);
        [dateView pf_layoutButtonWithEdgeInsetsStyle:PFButtonEdgeInsetsStyleRight imageTitleSpace:.0f];
        [self.view addSubview:dateView];
        [tempDates addObject:dateView];
    }];
    _events = tempDates.copy;
    return _events;
}

- (NSTimer *)timer {
    if (_timer) {
        return _timer;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self setInfo];
    return _timer;
}


- (NSTimer *)dateTimer {
    if (_dateTimer) {
        return _dateTimer;
    }
    _dateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setDate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_dateTimer forMode:NSRunLoopCommonModes];
    [self setDate];
    return _dateTimer;
}

@end
