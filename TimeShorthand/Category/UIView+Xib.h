//
//  UIView+Xib.h
//  FYT4Student
//
//  Created by David on 2017/5/8.
//  Copyright © 2017年 YueKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (xib)

+ (instancetype)viewFromXib;
+ (instancetype)viewFromXibWithOwner:(id)owner;

/**
 调试查看当前视图上的所有视图颜色
 */
- (void)debugSubViewColor;

@end

@interface UIViewController (xib)

+ (instancetype)viewControllerFromXib;

@end

