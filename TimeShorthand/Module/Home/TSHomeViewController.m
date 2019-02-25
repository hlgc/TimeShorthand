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
    
    _ageButton = [UILabel new];
    _ageButton.text = @"你23.938998989389岁了";
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchShare)];
}

- (void)onTouchMenu {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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

- (void)onTouchDateView:(UIButton *)button {
    
}

#pragma mark - Private
- (void)savePhotoToAlbum {
    //保存图片到本地
    [LHHudTool showLoadingWithMessage:@"保存中"];
    [TSTools savePhotoToCustomAlbumWithName:@"小灯塔" photo:[self createShareImage] saveBlock:^(int code, NSString *message) {
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
    NSArray *tempDatas = @[@"年",@"月",@"周",@"时",@"分",@"秒"];
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
    NSArray *tempDatas = @[@"睡觉 12344次",@"做澡 12344次",@"旅行 12344次",@"听歌 12344次"];
    NSMutableArray *tempDates = @[].mutableCopy;
    [tempDatas enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *dateView = [UIButton new];
        dateView.titleLabel.font = [UIFont pf_PingFangSC_LightWithSize:14.0f];
        [dateView setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
        [dateView setTitle:string forState:UIControlStateNormal];
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

@end
