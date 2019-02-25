//
//  TSPersonalCenterCell.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewCell.h"
#import "TSCommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSPersonalCenterCell : TSTableViewCell

@property (nonatomic, strong) TSCommonModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

NS_ASSUME_NONNULL_END
