//
//  TSEventModel.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSEventModel : NSObject

@property (nonatomic, copy) NSString *name;
// 多久一次, 1 -> 每一天  30->每月一次  183->半年一次
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL selected;

@end
