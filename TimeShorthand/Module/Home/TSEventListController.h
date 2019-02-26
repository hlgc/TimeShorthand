//
//  TSEventListController.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewController.h"


@interface TSEventListController : TSTableViewController

@property (nonatomic, copy) void(^didCompleteBlcok) (id model);

@end
