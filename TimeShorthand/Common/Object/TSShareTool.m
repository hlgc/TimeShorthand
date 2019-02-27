//
//  TSShareTool.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/23.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSShareTool.h"
#import <UMSocialCore/UMSocialPlatformConfig.h>
#import <UMSocialCore/UMSocialCore.h>

@implementation TSShareTool

#pragma mark - Public
+ (void)configUShare {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5c715dcfb465f5fa5a000074"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}

+ (BOOL)openUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = NO;
    if (url && sourceApplication && annotation) {
        result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    } else if (url && annotation && !sourceApplication) {
        result = [[UMSocialManager defaultManager]  handleOpenURL:url options:annotation];
    } else {
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return result;
}

+ (void)shareImageToPlatformType:(YKShareType)platformType
                      shareImage:(UIImage *)shareImage {
    [self shareImageToPlatformType:platformType shareImage:shareImage title:nil descr:nil];
}

+ (void)shareImageToPlatformType:(YKShareType)platformType
                      shareImage:(UIImage *)shareImage
                           title:(NSString *)title
                           descr:(NSString *)descr {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    NSString *thumbURL = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UIImage *thumb = [UIImage imageNamed:@"icon-1024"];
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:descr thumImage:thumb];
    //设置网页地址
    shareObject.shareImage = shareImage;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    //    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    //    UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
    UMSocialPlatformType shareType;
    switch (platformType) {
        case YKShareType_WechatTimeLine:
            shareType = UMSocialPlatformType_WechatTimeLine;
            break;
        case YKShareType_QQ:
            shareType = UMSocialPlatformType_QQ;
            break;
        default:
            shareType = UMSocialPlatformType_WechatSession;
            break;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error || ![data isKindOfClass:[UMSocialShareResponse class]]) {
            [LHHudTool showErrorWithMessage:@"分享失败!"];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            return;
        }
        UMSocialShareResponse *resp = data;
        //分享结果消息
        UMSocialLogInfo(@"response message is %@",resp.message);
        //第三方原始返回的数据
        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
        [LHHudTool showSuccessWithMessage:@"分享成功!"];
    }];
}

#pragma mark - Prvite

+ (void)configUSharePlatforms {
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

+ (void)confitUShareSettings {
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     
     微信AppKey所属账号：kanchangxin@yueke100.net
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx406264235aadf29c" appSecret:@"05ab3a52d30367e196f1ca504bd3c49f" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101556612"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}

@end
