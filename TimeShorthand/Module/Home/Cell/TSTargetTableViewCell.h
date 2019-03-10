//
//  TSTargetTableViewCell.h
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewCell.h"
#import "TSTargetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSTargetTableViewCell : TSTableViewCell

@property (nonatomic, strong) TSTargetModel *model;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
