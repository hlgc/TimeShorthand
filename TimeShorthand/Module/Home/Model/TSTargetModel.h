//
//  TSTargetModel.h
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTargetModel : NSObject

@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *time;
// 0->进行中  1->已完成  2->已过期
@property (nonatomic, assign) NSInteger state;

@end

