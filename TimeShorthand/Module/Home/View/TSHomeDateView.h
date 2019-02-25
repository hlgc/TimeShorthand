//
//  TSHomeDateView.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSHomeDateView : TSView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subTitleLabel;

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
