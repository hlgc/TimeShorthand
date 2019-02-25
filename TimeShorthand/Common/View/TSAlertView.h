//
//  TSAlertView.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSView.h"

typedef void(^TSAlertViewDidClickItemBlock) (NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface TSAlertView : TSView

- (void)show;

- (instancetype)initWithTitle:(NSString *)title message:(NSString*)message alertBlock:(TSAlertViewDidClickItemBlock)alertBlock cancelTitle:(NSString*)cancelTitle otherTitles:(NSString*)otherTitles, ...  NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
