//
//  TSEventModel.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSEventModel.h"

@implementation TSEventModel

- (NSInteger)day {
    if (_day) {
        return _day;
    }
    _day = 1;
    return _day;
}
    
@end
