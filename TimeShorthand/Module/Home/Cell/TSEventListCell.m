//
//  TSEventListCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSEventListCell.h"

@interface TSEventListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selecedImage;


@end

@implementation TSEventListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        SAFE_BLOCK(self.didClickItemCellBlock, self.model);
    }]];
}

- (void)setModel:(TSEventModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    _selecedImage.alpha = model.selected;
}

@end
