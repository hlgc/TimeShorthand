//
//  TSLoginTextField.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSLoginTextField.h"

@interface TSLoginTextField ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) NSString *leftImageName;

@end

@implementation TSLoginTextField

- (instancetype)initWithLeftImageName:(NSString *)leftImageName; {
    self = [super initWithFrame:CGRectZero];
    if (!self) {
        return nil;
    }
    _leftImageName = leftImageName;
    [self setupInit];
    [self addLineView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupInit];
    [self addLineView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineView.size = CGSizeMake(self.width, .5f);
    _lineView.bottom = self.height;
}

- (void)setupInit {
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_leftImageName]];
    leftView.contentMode = UIViewContentModeCenter;
    leftView.size = CGSizeMake(40.0f, 20.0f);
    self.leftView = leftView;
    
    //    self.keyboardType = UIKeyboardTypeNumberPad;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addLineView {
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_GREY;
    [self addSubview:_lineView];
}

@end
