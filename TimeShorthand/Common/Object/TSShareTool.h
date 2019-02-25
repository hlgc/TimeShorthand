//
//  TSShareTool.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/23.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YKShareType) {
    /**
     微信聊天
     */
    YKShareType_WechatSession = 0,
    /**
     微信朋友圈
     */
    YKShareType_WechatTimeLine = 1,
    /**
     QQ聊天页面
     */
    YKShareType_QQ = 2,
    /**
     复制
     */
    YKShareType_Copy = 3,
};


@interface TSShareTool : NSObject

+ (void)configUShare;

// 返回NO->其他如支付等SDK的回调
+ (BOOL)openUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+ (void)shareImageToPlatformType:(YKShareType)platformType
                      shareImage:(UIImage *)shareImage;
+ (void)shareImageToPlatformType:(YKShareType)platformType
                      shareImage:(UIImage *)shareImage
                           title:(NSString *)title
                           descr:(NSString *)descr;

@end
