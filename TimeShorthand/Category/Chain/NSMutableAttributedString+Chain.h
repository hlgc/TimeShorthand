//
//  NSMutableAttributedString+Chain.h
//  链式编程
//
//  Created by liuhao on 2017/5/26.
//  Copyright © 2017年 Lenhart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+Attributes.h"

@interface NSMutableAttributedString (Chain)

+ (NSMutableAttributedString *)pf_makeAttributedString:(NSString *)string attributes:(void(^)(NSMutableDictionary *make))block;

- (NSMutableAttributedString *)pf_addAttributedString:(NSString *)string attributes:(void(^)(NSMutableDictionary *make))block;

@end
