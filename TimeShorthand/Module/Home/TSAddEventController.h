//
//  TSAddEventController.h
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSViewController.h"
#import "TSNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSAddEventController : TSViewController

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, copy) void (^didCompleteBlock) (NSMutableArray *datas);
@end

NS_ASSUME_NONNULL_END
