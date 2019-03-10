//
//  TSAddTargetController.h
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSViewController.h"
#import "TSNavigationController.h"
#import "TSTargetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSAddTargetController : TSViewController

@property (nonatomic, copy) void (^didCompleteBlock) (TSTargetModel *model);

@end

NS_ASSUME_NONNULL_END
