//
//  TSUserTool.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSUserTool.h"

static TSUserTool  *_userTool = nil;

@implementation TSUserTool

+ (TSUserTool *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userTool = [[self alloc] init];
    });
    return _userTool;
}

+ (BOOL)isLogin {
    return TSUserTool.sharedInstance.user.hash;
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(PFErrorBlock)complete {
    AVUser *user = [AVUser user];
    user.username = username;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error && error.code != 202) {
            SAFE_BLOCK(complete, error);
            return ;
        }
        /// 已注册
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                SAFE_BLOCK(complete, error);
                return ;
            }
            [TSUserTool sharedInstance].user = [[TSUser alloc] initWithAVUser:user];
            SAFE_BLOCK(complete, nil);
        }];
    }];
}

+ (void)logOut {
    [AVUser logOut];
    _userTool.user = nil;
}

- (TSUser *)user {
    if (_user) {
        return _user;
    }
    AVUser *user = [AVUser currentUser];
    if (!user) {
        return nil;
    }
    _user = [[TSUser alloc] initWithAVUser:user];
    return _user;
}

@end
