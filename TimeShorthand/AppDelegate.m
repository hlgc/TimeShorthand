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

@interface AppDelegate ()

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
            TSNavigationController *navigationController = [[TSNavigationController alloc] initWithRootViewController:[[TSHomeViewController alloc] init]];
            TSLeftViewController *leftMenuViewController = [[TSLeftViewController alloc] init];
            MMDrawerController *sideMenuViewController = [[MMDrawerController alloc]
                                                          initWithCenterViewController:navigationController
                                                          leftDrawerViewController:leftMenuViewController
                                                          rightDrawerViewController:nil];
            [sideMenuViewController setMaximumRightDrawerWidth:UIScreen.mainScreen.bounds.size.width * 0.7f];
            [sideMenuViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [sideMenuViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            rootViewController = sideMenuViewController;
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

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    return _window;
}

@end
