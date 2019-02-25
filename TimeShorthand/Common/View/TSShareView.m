//
//  TSShareView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/23.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSShareView.h"


@interface TSShareView ()

@property (weak, nonatomic) IBOutlet UIButton *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, copy) void(^complete)(YKShareType type);

@end

@implementation TSShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentViewHeight.constant += [UIView safeAreaBottom];
}

+ (void)showWithComplete:(void(^)(YKShareType type))complete {
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    TSShareView *shareView = [self viewFromXib];
    shareView.complete = complete;
    shareView.frame = superView.bounds;
    [shareView layoutIfNeeded];
    [superView addSubview:shareView];
    
    shareView.contenBottom.constant = .0f;
    lh_animations(^{
        shareView.bgView.alpha = .5f;
        [shareView layoutIfNeeded];
    }, nil);
}

- (void)dismiss {
    self.contenBottom.constant = -(100 + [UIView safeAreaBottom]);
    lh_animations(^{
        self.bgView.alpha = .0f;
        [self layoutIfNeeded];
    }, ^{
        [self removeFromSuperview];
    });
}

- (IBAction)onTouchgView:(id)sender {
    [self dismiss];
}

- (IBAction)onTouchShareButton:(UIButton *)sender {
    SAFE_BLOCK(self.complete, sender.tag);
    [self onTouchgView:nil];
}


@end
