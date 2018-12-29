//
//  TSNavigationController.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSNavigationController.h"

@interface TSNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic ,strong) id popDelegate;

@end

@implementation TSNavigationController

// 设置导航栏的主题
+ (void)load {
    // 设置导航样式
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    // 1.设置导航条的背景
    //导航条颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // 2.设置栏的字体
//    [navBar setTitleTextAttributes:[NSMutableDictionary dictionary].pf_font([UIFont pf_PingFangSC_MediumWithSize:20.0f]).pf_color([UIColor pf_colorWithHex:0x404345])];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSMutableDictionary dictionary].pf_font([UIFont systemFontOfSize:0.1]).pf_color([UIColor clearColor]) forState:UIControlStateNormal];
    navBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    [self.navigationBar setShadowImage:[UIImage new]]; // 去除navBar下的1px的横线
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航控制器的代理
    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (self.childViewControllers.count == 1) { // 根控制器
        // 如果是根控制器,设回手势代理
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
    if (self.childViewControllers.count) { // 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        UIImage *backImage = [[UIImage imageNamed:@"nav_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:0 target:self action:@selector(back)];
        
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

#pragma mark - 转屏控制
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.visibleViewController shouldAutorotate];
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - 状态栏控制
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}

@end
