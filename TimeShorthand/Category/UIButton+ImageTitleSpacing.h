//
//  UIButton+ImageTitleSpacing.h
//  小灯塔
//
//  Created by liuhao on 2018/8/9.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PFButtonEdgeInsetsStyle) {
    PFButtonEdgeInsetsStyleTop, // image在上，label在下
    PFButtonEdgeInsetsStyleLeft, // image在左，label在右
    PFButtonEdgeInsetsStyleBottom, // image在下，label在上
    PFButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)pf_layoutButtonWithEdgeInsetsStyle:(PFButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
