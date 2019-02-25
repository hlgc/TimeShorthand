//
//  TSHomeDateView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSHomeDateView.h"


@interface TSHomeDateView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation TSHomeDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont pf_PingFangSC_MediumWithSize:16.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.font = [UIFont pf_PingFangSC_LightWithSize:15.0f];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.textColor = COLOR_FONT_GREY;
    [self addSubview:_subTitleLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    [_subTitleLabel sizeToFit];
    _subTitleLabel.centerX = _titleLabel.centerX = self.width * .5f;
    _titleLabel.bottom = self.height * .5f - 2.5f;
    
    _subTitleLabel.top = _titleLabel.bottom + 5.0f;
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    _titleLabel.text = title;
    _subTitleLabel.text = subTitle;
}

@end
