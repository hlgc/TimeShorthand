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

@interface TSHomeViewController ()

@property (nonatomic, strong) XLClock *clock;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *topLine;

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
    _nameLabel.text = @"“哈哈哟哟”";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont pf_PingFangSC_RegularWithSize:18.0f];
    [self.view addSubview:_nameLabel];
    
    _ageButton = [UILabel new];
    _ageButton.text = @"你已经存在23.938991年了";
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
}

- (void)setupInit {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchShare)];
}

- (void)onTouchMenu {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)onTouchShare {
    
}

@end
