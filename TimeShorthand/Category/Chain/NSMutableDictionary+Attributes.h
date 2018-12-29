//
//  NSMutableDictionary+Attributes.h
//  链式编程
//
//  Created by liuhao on 2017/5/26.
//  Copyright © 2017年 Lenhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableDictionary (Attributes)

- (NSMutableDictionary *(^)(UIColor *))pf_color;
- (NSMutableDictionary *(^)(UIFont *))pf_font;
- (NSMutableDictionary *(^)(NSMutableParagraphStyle *))pf_paraStyle;

@end
