//
//  TSNotiSwitchView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSNotiSwitchView.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface TSNotiSwitchView ()

@property (nonatomic, strong) UILabel *statuLb;
@property (nonatomic, strong) UILabel *remindLb;
/** 已关闭时的箭头 */
@property (nonatomic, strong) UIImageView *closeArrowImageView;

@end

@implementation TSNotiSwitchView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = 106.0f;
        [self setupUI];
        [self addTarget:self action:@selector(clickNotiSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
        
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] init];
    [self addSubview:icon];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.image = [UIImage imageNamed:@"noti"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *titleLb = [[UILabel alloc] init];
    [self addSubview: titleLb];
    titleLb.font = [UIFont pf_fontWithName:@"PingFangSC-Regular" size:16];
    titleLb.textColor = COLOR_FONT_BLACK;
    titleLb.text = @"Message switch";
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.left.mas_equalTo(icon.mas_right).offset(15);
    }];
    
    UILabel *statuLb = [[UILabel alloc] init];
    [self addSubview: statuLb];
    statuLb.font = [UIFont pf_fontWithName:@"PingFangSC-Light" size:14];
    statuLb.textColor = [UIColor redColor];
    statuLb.text = @"Closed";
    self.statuLb = statuLb;
    [statuLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.right.mas_equalTo(-27);
    }];
    
    UILabel *remindLb = [[UILabel alloc] init];
    [self addSubview: remindLb];
    remindLb.font = [UIFont pf_fontWithName:@"PingFangSC-Light" size:12];
    remindLb.textColor = COLOR_FONT_GREY;
    remindLb.text = @"If you need to shut down, please make changes in the system [settings] notification.";
    self.remindLb = remindLb;
    [remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(icon.mas_bottom).offset(15);
        make.left.mas_equalTo(icon);
    }];
    
    [self addSubview:self.closeArrowImageView];
    [self.closeArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.right.mas_equalTo(-30);
    }];
}

// 刷新数据
- (void)reloadData {
    
    BOOL isEnable = YES;
    if (@available(iOS 10 , *)) {
        WEAK_SELF
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) { STRONG_SELF
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                    // 没权限
                    self.statuLb.text = @"Closed";
                    self.statuLb.textColor = [UIColor redColor];
                    self.remindLb.text = @"If you need to open it, please modify it in the System [Settings] Notification.";
                    self.closeArrowImageView.hidden = NO;
                    [self.statuLb mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-52);
                    }];
                } else {
                    self.statuLb.text = @"Opened";
                    self.statuLb.textColor = COLOR_FONT_GREY;
                    self.remindLb.text = @"If you need to shut down, please make changes in the system [settings] notification.";
                    self.closeArrowImageView.hidden = YES;
                    [self.statuLb mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-27);
                    }];
                }
            });
            
        }];
    } else if (@available(iOS 8 , *)) {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            isEnable = NO;
        }
    }
    
    if (isEnable) {
        
        self.statuLb.text = @"Opened";
        self.statuLb.textColor = COLOR_FONT_GREY;
        self.remindLb.text = @"If you need to shut down, please make changes in the system [settings] notification.";
        
        self.closeArrowImageView.hidden = YES;
        [self.statuLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-27);
        }];
    } else {
        
        self.statuLb.text = @"Closed";
        self.statuLb.textColor = [UIColor redColor];;
        self.remindLb.text = @"If you need to open it, please modify it in the System [Settings] Notification.";
        
        self.closeArrowImageView.hidden = NO;
        [self.statuLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-52);
        }];
    }
}

// 点击设置消息开关
- (void)clickNotiSwitchBtn {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - getter
- (UIImageView *)closeArrowImageView {
    if (!_closeArrowImageView) {
        _closeArrowImageView = [[UIImageView alloc] init];
        _closeArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _closeArrowImageView.image = [UIImage imageNamed:@"arrow"];
    }
    return _closeArrowImageView;
}

@end
