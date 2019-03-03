//
//  TSCollectionViewCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/3.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSCollectionViewCell.h"

@implementation TSCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    return [self cellWithCollectionView:collectionView identifier:[self identifer] forIndexPath:indexPath];
}
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    TSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupInit];
    [self addSubviews];
    [self addConstraints];
}

- (void)setupInit {
    //    UIView *selectedBackgroundView = [[UIView alloc] init];
    //    selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"0xf7fbff"];
    //    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)addSubviews {
}
- (void)addConstraints {}

+ (NSString *)identifer {
    return NSStringFromClass([self class]);
}

@end
