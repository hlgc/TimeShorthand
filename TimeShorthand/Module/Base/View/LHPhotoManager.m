//
//  LHPhotoManager.m
//  小灯塔
//
//  Created by liuhao on 2018/11/2.
//  Copyright © 2018 TheTiger. All rights reserved.
//

#import "LHPhotoManager.h"
#import "UIButton+ImageTitleSpacing.h"

@implementation LHPhotoManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    [self setupInit];
    [self configurationBar];
    return self;
}

- (instancetype)initWithType:(HXPhotoManagerSelectedType)type {
    self = [super initWithType:type];
    if (!self) {
        return self;
    }
    [self setupInit];
    [self configurationBar];
    return self;
}

- (void)setupInit {
    self.configuration.photoCanEdit = NO;
    self.configuration.videoCanEdit = NO;
    self.configuration.openCamera = NO;
    self.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
}

- (void)configurationBar {
    
//    self.configuration.photoListBottomView = ^(HXPhotoBottomView *bottomView) {
////        bottomView.originalBtn.imageEdgeInsets = UIEdgeInsetsZero;
////        bottomView.originalBtn.titleEdgeInsets = UIEdgeInsetsZero;
//        [bottomView.originalBtn setTitleColor:[UIColor pf_colorWithHex:0x666666] forState:UIControlStateNormal];
//        [bottomView.originalBtn setTitleColor:[[UIColor pf_colorWithHex:0x666666] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
//        [bottomView.originalBtn pf_layoutButtonWithEdgeInsetsStyle:10 imageTitleSpace:8.0f];
//        bottomView.center = CGPointMake(bottomView.width * .5f, bottomView.height * .5f);
//    };
//    self.configuration.previewBottomView = ^(HXPhotoPreviewBottomView *bottomView) {
//        bottomView.bgView.tintColor = [UIColor pf_colorWithHex:0x666666];
//    };
//    self.configuration.navigationBar = ^(UINavigationBar *navigationBar, UIViewController *viewController) {
//        [navigationBar setBarTintColor:[UIColor whiteColor]];
//        [navigationBar setTintColor:COLOR_FONT_BLACK];
////        [navigationBar setTitleTextAttributes:[NSMutableDictionary dictionary].pf_font([UIFont pf_PingFangSC_MediumWithSize:17.0f]).pf_color(COLOR_FONT_BLACK)];
//    };
    self.configuration.themeColor = [UIColor pf_colorWithHex:0xFFE266];
    self.configuration.selectedTitleColor = [UIColor pf_colorWithHex:0x354048];
}

@end
