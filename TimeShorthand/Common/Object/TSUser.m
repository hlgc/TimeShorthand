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

@end
