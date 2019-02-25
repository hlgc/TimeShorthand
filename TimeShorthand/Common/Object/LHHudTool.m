//
//  LHHudTool.m
//  小灯塔
//
//  Created by 李小南 on 2018/4/27.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import "LHHudTool.h"

#import <MBProgressHUD.h>
#import <UIImage+GIF.h>

#define kDelayTime 2.0

@implementation LHHudTool

/**
 隐藏HUD, 如果view为nil, 则默认隐藏主窗口的HUD

 @param view view
 */
+ (void)hideHUDAndView:(UIView *)view {
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }
}

/**
 隐藏HUD
 */
+ (void)hideHUD {
    [self hideHUDAndView:nil];
}

/**
 显示成功message, 默认显示在窗口上

 @param message 文字
 */
+ (void)showSuccessWithMessage:(NSString *)message {
    [self showSuccessWithMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 显示成功message

 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)view {
    [self showSuccessWithMessage:message inView:view withDelay:kDelayTime];
}

/**
 显示成功message

 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)view withDelay:(NSTimeInterval)afterDelay {
    
    if (message.length == 0) { return; }
    if(!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDAndView:view]; // 先隐藏
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;//样式
    // 方框背景颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.bezelView.color = [hud.bezelView.color colorWithAlphaComponent:0.8];//背景图
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:afterDelay];
    hud.removeFromSuperViewOnHide = YES;
}

/**
 显示错误message, 默认显示在窗口上
 
 @param message 文字
 */
+ (void)showErrorWithMessage:(NSString *)message {
    [self showErrorWithMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 显示错误message
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(UIView *)view {
    [self showErrorWithMessage:message inView:view withDelay:kDelayTime];
}

/**
 显示错误message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(UIView *)view withDelay:(NSTimeInterval)afterDelay {
    if (message.length == 0) { return; }
    if(!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDAndView:view]; // 先隐藏
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;//样式
    // 方框背景颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.bezelView.color = [hud.bezelView.color colorWithAlphaComponent:0.8];//背景图
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:afterDelay];
    hud.removeFromSuperViewOnHide = YES;
}

/**
 *  在窗口上显示菊花
 */
+ (void)showLoading {
    [self showLoadingInView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  在view上显示菊花
 */
+ (void)showLoadingInView:(UIView *)view {
    [self showLoadingWithMessage:nil inView:view];
}

/**
 *  在窗口上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingWithMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  在view上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)view {
    if(!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDAndView:view];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = YES;
    hud.bezelView.color = [UIColor whiteColor];//背景颜色
    hud.bezelView.color = [hud.bezelView.color colorWithAlphaComponent:0.8];//背景图
    if (message.length) {
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.label.textColor = [UIColor blackColor];
        hud.label.font = [UIFont systemFontOfSize:14];
    }
}

/**
 在窗口上显示自定义GIFLoading, 背景默认透明
 */
+ (void)showGIFLoading {
    [self showGIFLoadingInView:[UIApplication sharedApplication].keyWindow];
}

/**
 在指定的view上显示自定义GIFLoading, 背景默认透明

 @param view 显示在哪个view上
 */
+ (void)showGIFLoadingInView:(UIView *)view {
    [self showGIFLoadingInView:view bgColor:[UIColor clearColor]];
}

/**
 在指定的view上显示自定义GIFLoading

 @param view 显示在哪个view上
 @param bgColor 背景颜色, 遮盖
 */
+ (void)showGIFLoadingInView:(UIView *)view bgColor:(UIColor *)bgColor {
    if(!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDAndView:view];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self gifCustomView];
    hud.contentColor = bgColor;
    hud.bezelView.color = bgColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
}

+ (MBRoundProgressView *)gifCustomView {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif_mi_loading"ofType:@"gif"]];
    UIImageView *gifImageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFWithData:data]];
    CGRect gifFrame = CGRectMake(0, 0, 37, 37);
    gifImageView.frame = gifFrame;
    
    MBRoundProgressView *proView = [MBRoundProgressView new];
    [proView addSubview:gifImageView];
    
    return proView;
}

- (void)backButtonDidClick:(UIButton *)button {
    [[button viewController].navigationController popViewControllerAnimated:YES];
}

@end
