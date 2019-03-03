//
//  TSCollectionViewCell.h
//  TimeShorthand
//
//  Created by liuhao on 2019/3/3.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier  forIndexPath:(NSIndexPath *)indexPath;

- (void)setupInit;
- (void)addSubviews;
- (void)addConstraints;
+ (NSString *)identifer;

@end
