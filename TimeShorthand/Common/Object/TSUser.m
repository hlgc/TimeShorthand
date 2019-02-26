//
//  TSUser.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSUser.h"

@implementation TSUser

- (instancetype)initWithAVUser:(AVUser *)user {
    self = [TSUser modelWithJSON:[user objectForKey:kLocalDataKey]];
    return self;
}

- (NSInteger)surplusLife {
    if (_surplusLife) {
        return _surplusLife;
    }
    TSUser *user = TSUserTool.sharedInstance.user;
    NSInteger life = user.life.integerValue * 365 * 24 * 60 * 60;
    life = user.birthday.integerValue + life;
    NSTimeInterval current = [[NSDate new] timeIntervalSince1970];
    
    // 还剩多少天
    NSInteger count = (life - current) / 24 / 60 / 60;
    _surplusLife = count;
    return count;
}

@end
