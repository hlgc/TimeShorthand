//
//  NSMutableDictionary+Attributes.m
//  链式编程
//
//  Created by liuhao on 2017/5/26.
//  Copyright © 2017年 Lenhart. All rights reserved.
//

#import "NSMutableDictionary+Attributes.h"

@implementation NSMutableDictionary (Attributes)

- (NSMutableDictionary *(^)(UIColor *))pf_color {
    return ^id (UIColor *Color) {
        [self setObject:Color forKey:NSForegroundColorAttributeName];
        return self;
    };
}

- (NSMutableDictionary *(^)(UIFont *))pf_font {
    return ^id (UIFont *Font) {
        [self setObject:Font forKey:NSFontAttributeName];
        return self;
    };
}

- (NSMutableDictionary *(^)(NSMutableParagraphStyle *))pf_paraStyle {
    return ^id (NSMutableParagraphStyle *ParaStyle) {
        [self setObject:ParaStyle forKey:NSParagraphStyleAttributeName];
        return self;
    };
}

//- (NSMutableDictionary *(^)(NSMutableParagraphStyle *))pf_paraStyle {
//    return ^id (NSMutableParagraphStyle *ParaStyle) {
//        [self setObject:ParaStyle forKey:NSParagraphStyleAttributeName];
//        return self;
//    };
//}
//
//NSLinkAttributeName

@end
