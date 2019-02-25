//
//  UIView+Xib.m
//  FYT4Student
//
//  Created by David on 2017/5/8.
//  Copyright © 2017年 YueKe. All rights reserved.
//

#import "UIView+Xib.h"

@implementation UIView (xib)

+ (instancetype)viewFromXib {
    return [self viewFromXibWithOwner:self];
}

+ (instancetype)viewFromXibWithOwner:(id)owner {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:nil][0];
}

- (void)debugSubViewColor {
    for (UIView *subView in self.subviews) {
        [subView debugSubViewColor];
    }
}

@end

@implementation UIViewController (xib)

+ (instancetype)viewControllerFromXib {
    Class cls = [self class];
    return [[cls alloc] initWithNibName:NSStringFromClass(cls) bundle:nil];
}

@end
