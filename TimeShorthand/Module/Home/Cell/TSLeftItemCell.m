//
//  TSLeftItemCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSLeftItemCell.h"

@implementation TSLeftItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        SAFE_BLOCK(self.didClickItemCellBlock, self.model);
    }]];
}

- (void)setModel:(TSCommonModel *)model {
    _model = model;
    _iconImageView.image = [UIImage imageNamed:model.imagename];
    _titleLabel.text = model.title;
}

@end
