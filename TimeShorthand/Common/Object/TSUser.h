//
//  TSUser.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUser : AVUser

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *life;
/// 剩余生命
@property (nonatomic, assign) NSInteger surplusLife;
/// 时间戳
@property (nonatomic, copy) NSString *birthday;

- (instancetype)initWithAVUser:(AVUser *)user;

@end
