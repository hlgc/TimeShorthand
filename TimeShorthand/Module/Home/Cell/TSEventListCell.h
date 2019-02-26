//
//  TSEventListCell.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewCell.h"
#import "TSEventModel.h"

@interface TSEventListCell : TSTableViewCell

@property (nonatomic, copy) void(^didClickItemCellBlock)(TSEventModel *model);

@property (nonatomic, strong) TSEventModel *model;

@end
