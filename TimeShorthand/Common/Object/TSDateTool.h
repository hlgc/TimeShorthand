//
//  TSDateTool.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TSDateTool : NSObject
+ (NSDateFormatter *)dateFormatter;
+ (NSString *)formateDateWithTimestamp:(NSString *)timestamp;
@end
