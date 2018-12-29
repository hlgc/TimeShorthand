//
//  UIFont+LH.h
//  小灯塔
//
//  Created by Hasten on 2018/2/28.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (PFExtension)

+ (nullable UIFont *)pf_fontWithName:(NSString *_Nullable)fontName size:(CGFloat)fontSize;

#pragma mark - 快速返回字体
#pragma mark PingFangSC
+ (nullable UIFont *)pf_PingFangSC_RegularWithSize:(CGFloat)size;
+ (nullable UIFont *)pf_PingFangSC_LightWithSize:(CGFloat)size;
+ (nullable UIFont *)pf_PingFangSC_MediumWithSize:(CGFloat)size;
+ (nullable UIFont *)pf_PingFangSC_SemiboldWithSize:(CGFloat)size;
#pragma mark SourceHanSerifSC
+ (nullable UIFont *)pf_SourceHanSerifSC_BoldWithSize:(CGFloat)size;
#pragma mark DIN
+ (nullable UIFont *)pf_DIN_MediumWithSize:(CGFloat)size;

@end
