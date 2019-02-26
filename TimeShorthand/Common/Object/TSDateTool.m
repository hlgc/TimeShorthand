//
//  TSDateTool.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSDateTool.h"
#import "NSDate+PFAdd.h"

@implementation TSDateTool
+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

/**
 1分钟之内：显示 刚刚
 1~60分钟内：显示 XX分钟前
 1~24小时内-不跨天：显示 xx小时前
 1~24小时内-跨天：显示 昨天
 跨两天：显示 前天
 超过两天-没有跨年：显示 月日时分
 超过两天，且跨年：显示 年月日时分
 **/
+ (NSString *)formateDateWithTimestamp:(NSString *)timestamp {
    
    return nil;
}
@end
