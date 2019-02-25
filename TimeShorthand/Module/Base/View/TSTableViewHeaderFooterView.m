//
//  TSTableViewHeaderFooterView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewHeaderFooterView.h"

@implementation TSTableViewHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView {
    return [self viewWithTableView:tableView identifier:[self identifer]];
}

+ (instancetype)viewWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    TSTableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        view = [[[self class] alloc] initWithReuseIdentifier:identifier];
    }
    view.contentView.backgroundColor = [UIColor clearColor];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView = backgroundView;
    [self setupInit];
    [self addSubviews];
    [self addConstraints];
}

- (void)setupInit {}
- (void)addSubviews {}
- (void)addConstraints {}

+ (NSString *)identifer {
    return NSStringFromClass([self class]);
}

@end
