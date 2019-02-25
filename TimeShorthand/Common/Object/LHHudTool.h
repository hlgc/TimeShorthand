//
//  LHHudTool.h
//  小灯塔
//
//  Created by 李小南 on 2018/4/27.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHHudTool : NSObject
/**
 隐藏HUD
 */
+ (void)hideHUD;

/**
 隐藏HUD, 如果view为nil, 则默认隐藏主窗口的HUD
 
 @param view view
 */
+ (void)hideHUDAndView:(UIView *)view;

/**
 显示成功message, 默认显示在窗口上
 
 @param message 文字
 */
+ (void)showSuccessWithMessage:(NSString *)message;

/**
 显示成功message
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)view;

/**
 显示成功message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)view withDelay:(NSTimeInterval)afterDelay;

/**
 显示错误message, 默认显示在窗口上
 
 @param message 文字
 */
+ (void)showErrorWithMessage:(NSString *)message;

/**
 显示错误message
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(UIView *)view;

/**
 显示错误message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(UIView *)view withDelay:(NSTimeInterval)afterDelay;

/**
 *  在窗口上显示菊花
 */
+ (void)showLoading;

/**
 *  在view上显示菊花
 */
+ (void)showLoadingInView:(UIView *)view;

/**
 *  在窗口上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message;

/**
 *  在view上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)view;

/**
 在窗口上显示自定义GIFLoading, 背景默认透明
 */
+ (void)showGIFLoading;

/**
 在指定的view上显示自定义GIFLoading, 背景默认透明
 
 @param view 显示在哪个view上
 */
+ (void)showGIFLoadingInView:(UIView *)view;

/**
 在指定的view上显示自定义GIFLoading
 
 @param view 显示在哪个view上
 @param bgColor 背景颜色, 遮盖
 */
+ (void)showGIFLoadingInView:(UIView *)view bgColor:(UIColor *)bgColor;

/**
 GIFLoading + 伪导航栏加载
 
 @param view 显示在哪个view上
 */
+ (void)showGIFLoadingAndFakeNavBarInView:(UIView *)view;
@end
