//
//  TSLeftItemCell.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewCell.h"
#import "TSCommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSLeftItemCell : TSTableViewCell

@property (nonatomic, copy) void(^didClickItemCellBlock)(TSCommonModel *model);

@property (nonatomic, strong) TSCommonModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
