//
//  TSEventListController.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewController.h"
@class TSEventModel;

@interface TSEventListController : TSTableViewController

@property (nonatomic, copy) void(^didCompleteBlcok) (id model);
@property (nonatomic, strong) TSEventModel *s_model;

@end
