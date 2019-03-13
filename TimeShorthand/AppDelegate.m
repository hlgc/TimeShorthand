//
//  AppDelegate.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/27.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "AppDelegate.h"
#import "TSHomeViewController.h"
#import "TSLeftViewController.h"
#import "TSNavigationController.h"
#import <MMDrawerController.h>
#import "TSShareTool.h"
#import "TSUserTool.h"
#import "TSLoginController.h"
#import "TSSetPropertyController.h"
#import <IQKeyboardManager.h>
#import <CYLTabBarController.h>
#import "TSTargetController.h"
#import "TSRecollectController.h"

@interface AppDelegate () <UITabBarControllerDelegate, CYLTabBarControllerDelegate>

@property (nonatomic, strong) CYLTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TSShareTool configUShare];
    [self setupKeyboardManager];
    [self setUpLeanCloudWithOptions:launchOptions];
    [self setupRootViewController];
    
    
    return YES;
}

- (void)setupKeyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

- (void)setupRootViewController {
    UIViewController *rootViewController = nil;
    if (TSUserTool.isLogin) {
        if (![TSUserTool sharedInstance].user.name.length ||
            ![TSUserTool sharedInstance].user.life.length ||
            ![TSUserTool sharedInstance].user.birthday.length) {
            /// 设置页面
            rootViewController = [TSSetPropertyController new];
        } else {
//            TSNavigationController *navigationController = [[TSNavigationController alloc] initWithRootViewController:[[TSHomeViewController alloc] init]];
//            TSLeftViewController *leftMenuViewController = [[TSLeftViewController alloc] init];
//            MMDrawerController *sideMenuViewController = [[MMDrawerController alloc]
//                                                          initWithCenterViewController:navigationController
//                                                          leftDrawerViewController:leftMenuViewController
//                                                          rightDrawerViewController:nil];
//            [sideMenuViewController setMaximumRightDrawerWidth:UIScreen.mainScreen.bounds.size.width * 0.7f];
//            [sideMenuViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//            [sideMenuViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            rootViewController = self.tabBarController;
        }
    } else {
        rootViewController = [TSLoginController new];
    }
    
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}

- (void)setUpLeanCloudWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"luDXtGoUmkyO4HVQyIvg4GW9-9Nh9j0Va" clientKey:@"1uwbuQsI1O1DIT9Ut2947oNt"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
#ifdef DEBUG
    [AVOSCloud setAllLogsEnabled:YES];
#endif
}

#pragma mark - OpenURL
// 9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [TSShareTool openUrl:url sourceApplication:nil annotation:nil];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [TSShareTool openUrl:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


// 9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    BOOL result = [TSShareTool openUrl:url sourceApplication:nil annotation:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - UITabBarController
//AppDelegate.m
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    // 如果 PlusButton 也添加了点击事件，那么点击 PlusButton 后不会触发该代理方法。
    if ([control isKindOfClass:[CYLExternPlusButton class]]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
    } else if ([control isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        for (UIView *subView in control.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                animationView = subView;
            }
        }
    }
    
    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

#pragma mark - Getter
- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    return _window;
}

- (CYLTabBarController *)tabBarController {
    if (_tabBarController) {
        return _tabBarController;
    }
    
    NSArray *tabBarItemsAttributes = @[@{
                                           CYLTabBarItemImage : @"tabbar_time_n",
                                           CYLTabBarItemSelectedImage : @"tabbar_time",
                                           },
                                       @{
                                           CYLTabBarItemImage : @"cicre_tabbar_n",
                                           CYLTabBarItemSelectedImage : @"cicre_tabbar",
                                           },
                                       @{
                                           CYLTabBarItemImage : @"taget_tabbar_n",
                                           CYLTabBarItemSelectedImage : @"taget_tabbar",
                                           },
                                       @{
                                           CYLTabBarItemImage : @"me_tabbar_n",
                                           CYLTabBarItemSelectedImage : @"me_tabbar",
                                           }];
    TSNavigationController *homeNav = [[TSNavigationController alloc] initWithRootViewController:[[TSHomeViewController alloc] init]];
    TSNavigationController *cicreNav = [[TSNavigationController alloc] initWithRootViewController:[[TSRecollectController alloc] init]];
    TSNavigationController *tagetNav = [[TSNavigationController alloc] initWithRootViewController:[[TSTargetController alloc] init]];
    TSNavigationController *meNav = [[TSNavigationController alloc] initWithRootViewController:[[TSLeftViewController alloc] init]];
    
    _tabBarController = [CYLTabBarController new];
    _tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    [_tabBarController setViewControllers:@[
                                           homeNav,
                                           cicreNav,
                                           tagetNav,
                                           meNav,
                                           ]];
    _tabBarController.delegate = self;
    return _tabBarController;
}

@end
