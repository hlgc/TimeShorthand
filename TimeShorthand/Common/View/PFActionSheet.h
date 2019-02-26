//
//  PFActionSheet.h
//  PetFriend
//
//  Created by liuhao on 2018/12/18.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSView.h"

typedef void(^PFActionSheetwDidClickItemBlock) (NSInteger index);

@interface PFActionSheet : TSView

- (void)show;

- (instancetype)initWithMessage:(NSString*)message alertBlock:(PFActionSheetwDidClickItemBlock)alertBlock cancelTitle:(NSString*)cancelTitle otherTitles:(NSString*)otherTitles, ...  NS_REQUIRES_NIL_TERMINATION;

@end

