//
//  TSUserTool.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSUser.h"

@interface TSUserTool : NSObject

@property (nonatomic, strong) TSUser *user;

+ (TSUserTool *)sharedInstance;

+ (BOOL)isLogin;
+ (void)logOut;

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(PFErrorBlock)complete;
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password complete:(PFErrorBlock)complete;

@end


