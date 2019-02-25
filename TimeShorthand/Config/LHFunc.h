//
//  LHFunc.h
//  小灯塔
//
//  Created by liuhao on 2019/1/9.
//  Copyright © 2019 TheTiger. All rights reserved.
//

#ifndef LHFunc_h
#define LHFunc_h

// 延迟执行
NS_INLINE void lh_dispatch_delay_async(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

// 主线程执行
NS_INLINE void lh_dispatch_main_async(dispatch_block_t block) {
    if (!block) {
        return;
    }
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

// 全局线程执行
NS_INLINE void lh_dispatch_global_async(dispatch_block_t block) {
    if (!block) {
        return;
    }
    if ([NSThread isMainThread]) {
        dispatch_async(dispatch_get_global_queue(0, 0), block);
    } else {
        block();
    }
}

// 全局动画
NS_INLINE void lh_animations(dispatch_block_t block, dispatch_block_t completion) {
    if (!block) {
        return;
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        block();
    } completion:^(BOOL finished) {
        if (finished && completion) {
            completion();
        }
    }];
}

NS_INLINE void lh_animationsWithDuration(NSTimeInterval duration, dispatch_block_t block, dispatch_block_t completion) {
    if (!block) {
        return;
    }
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        block();
    } completion:^(BOOL finished) {
        if (finished && completion) {
            completion();
        }
    }];
}

NS_INLINE BOOL lh_colorEqualToColor(UIColor *color1, UIColor *color2) {
    if (CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
        return YES;
    }
    return NO;
}


#endif /* LHFunc_h */
