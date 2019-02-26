//
//  TSRecollectHeaderView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSRecollectHeaderView.h"

@interface TSRecollectHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TSRecollectHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.left = 15.0f;
    _titleLabel.centerY = self.height * .5f;
}

- (void)setupInit {
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;
}

- (void)addSubviews {
    [self addTitleLabel];
}

- (void)addTitleLabel {
    _titleLabel = [UILabel new];
    _titleLabel.text = @"2019年";
    _titleLabel.font = [UIFont pf_PingFangSC_RegularWithSize:18.0f];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
}

@end
