//
//  UIFont+LH.m
//  小灯塔
//
//  Created by Hasten on 2018/2/28.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import "UIFont+PFExtension.h"

@implementation UIFont (PFExtension)

+ (nullable UIFont *)pf_PingFangSC_RegularWithSize:(CGFloat)size {
    return [self pf_fontWithName:@"PingFangSC-Regular" size:size];
}

+ (nullable UIFont *)pf_PingFangSC_LightWithSize:(CGFloat)size {
    return [self pf_fontWithName:@"PingFangSC-Light" size:size];
}

+ (nullable UIFont *)pf_PingFangSC_MediumWithSize:(CGFloat)size {
    return [self pf_fontWithName:@"PingFangSC-Medium" size:size];
}

+ (nullable UIFont *)pf_PingFangSC_SemiboldWithSize:(CGFloat)size {
    return [self pf_fontWithName:@"PingFangSC-Medium" size:size];
}

+ (nullable UIFont *)pf_SourceHanSerifSC_BoldWithSize:(CGFloat)size {
    return [self pf_fontWithName:@"SourceHanSerifSC-Bold" size:size];
}

+ (nullable UIFont *)pf_DIN_MediumWithSize:(CGFloat)size {
    return [self pf_fontWithName:@"DIN-Medium" size:size];
}

+ (nullable UIFont *)pf_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    if (!fontName.length) {
        fontName = @"PingFangSC-Regular";
    }
    if (!fontSize) {
        fontSize = 12;
    }
    if (@available(iOS 10.0, *)) {
        return [UIFont fontWithName:fontName size:fontSize];
    } else {
        if ([fontName isEqualToString:@"PingFangSC-Regular"] ||
            [fontName isEqualToString:@"PingFangSC-Light"]) {
            return [UIFont systemFontOfSize:fontSize];
        } else if ([fontName isEqualToString:@"PingFangSC-Medium"] ||
                   [fontName isEqualToString:@"PingFangSC-Semibold"]) {
            return [UIFont boldSystemFontOfSize:fontSize];
        }
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

@end
