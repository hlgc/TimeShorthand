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
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [self dateFormatter];
        
        NSDate *nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate *needFormatDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time <= 60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        } else if (time <= 60*60) {  ////  一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前", mins];
        } else if (needFormatDate.isToday) {//今天
            [dateFormatter setDateFormat:@"HH:mm"];
            //// 在同一天
            int hours = time/(60*60);
            dateStr = [NSString stringWithFormat:@"%d小时前", hours];
        } else if (needFormatDate.isYesterday) {
            dateStr = @"昨天";
        } else if (needFormatDate.isBeforeYesterday) {
            dateStr = @"前天";
        } else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日 HH时mm分"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            } else {
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}
@end
