//
//  TSTableViewCell.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSTableViewCell.h"

@implementation TSTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [self cellWithTableView:tableView identifier:[self identifer]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    TSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupInit];
    [self addSubviews];
    [self addConstraints];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        SAFE_BLOCK(self.didClickSelfBlock);
    }]];
}

- (void)setupInit {
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    //    UIView *selectedBackgroundView = [[UIView alloc] init];
    //    selectedBackgroundView.backgroundColor = [UIColor clearColor];
    //    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)addSubviews {
}
- (void)addConstraints {}

+ (NSString *)identifer {
    return NSStringFromClass([self class]);
}


@end
