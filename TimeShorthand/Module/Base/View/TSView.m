//
//  TSView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSView.h"

@implementation TSView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    [self setupInit];
    [self addSubviews];
    [self addConstraints];
    [self addNotification];
    return self;
}

- (void)setupInit {
    
}

- (void)addSubviews {
}

- (void)addConstraints {
    
}

- (void)addNotification {
    
}

- (void)addEmptyView {
}

@end
