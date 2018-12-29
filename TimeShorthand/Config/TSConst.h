//
//  TSConst.h
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

typedef void(^PFVoidBlock) (void);
typedef void(^PFErrorBlock) (NSError *error);
typedef void(^PFIndexPathBlock) (NSIndexPath *indexPath);

extern CGFloat const kGallopItemMargin;

extern NSString *const kImageNameBannerPlaceholder;
extern NSString *const kImageNameGallopPlaceholder;
extern NSString *const kImageNameHeaderPlaceholder;;

extern NSString *const kLocalDataKey;

extern NSString *const kJPushSDKAppKey;
extern BOOL const kJPushIsProduction;

/// 服务器开小差了~
extern NSString *const kServiceErrorString;
extern NSInteger const kDefaultPageCount;

extern NSString *const kUIScrollViewDidChangeContentOffsetNotification;

/// 同意条款
extern NSString *const kConsentClauseKey;


