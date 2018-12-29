//
//  TSViewController.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSViewController.h"

@interface TSViewController ()

@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupInit];
    [self addSubviews];
    [self addConstraints];
    [self addNotification];}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.isHiddenNavBar animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setupInit {
    
}

- (void)addSubviews {
}

- (void)addConstraints {
    
}

- (void)addNotification {
    
}

- (void)addEmptyView {
}

#pragma mark - Getter
- (BOOL)isHiddenNavBar {
    return NO;
}

@end
