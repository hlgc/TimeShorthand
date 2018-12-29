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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    TSNavigationController *navigationController = [[TSNavigationController alloc] initWithRootViewController:[[TSHomeViewController alloc] init]];
    TSLeftViewController *leftMenuViewController = [[TSLeftViewController alloc] init];
    MMDrawerController *sideMenuViewController = [[MMDrawerController alloc]
                                                  initWithCenterViewController:navigationController
                                                  leftDrawerViewController:leftMenuViewController
                                                  rightDrawerViewController:nil];
//    [sideMenuViewController setShowsShadow:NO];
//    [sideMenuViewController setRestorationIdentifier:@"MMDrawer"];
    [sideMenuViewController setMaximumRightDrawerWidth:UIScreen.mainScreen.bounds.size.width * 0.772946859903382f];
    [sideMenuViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [sideMenuViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [sideMenuViewController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         MMDrawerControllerDrawerVisualStateBlock block;
//         block = [[MMExampleDrawerVisualStateManager sharedManager]
//                  drawerVisualStateBlockForDrawerSide:drawerSide];
//         if(block){
//             block(drawerController, drawerSide, percentVisible);
//         }
     }];
    self.window.rootViewController = sideMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
