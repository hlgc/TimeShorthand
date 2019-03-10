//
//  LHDatePicker.h
//  PetFriend
//
//  Created by liuhao on 2019/1/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSView.h"

typedef enum : NSUInteger {
    PFDatePickerViewDateTimeMode,//年月日,时分
    PFDatePickerViewDateMode,//年月日
    PFDatePickerViewTimeMode//时分
} PFDatePickerViewMode;

@interface PFDatePicker : TSView

+ (void)showWithDate:(NSDate *)date startYear:(NSInteger)startYear title:(NSString *)title mode:(PFDatePickerViewMode)mode complete:(void(^)(NSString *dateStr))complete;
+ (void)showWithTitle:(NSString *)title mode:(PFDatePickerViewMode)mode complete:(void(^)(NSString *dateStr))complete;
+ (void)showWitMode:(PFDatePickerViewMode)mode complete:(void(^)(NSString *dateStr))complete;
+ (void)showWithDate:(NSDate *)date complete:(void(^)(NSString *dateStr))complete;
+ (void)showWitComplete:(void(^)(NSString *dateStr))complete;


@end

