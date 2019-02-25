//
//  TSPersonalCenterCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSPersonalCenterCell.h"

@implementation TSPersonalCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(TSCommonModel *)model {
    _model = model;
    self.iconImageView.alpha = model.imagename.length;
    
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}

@end
