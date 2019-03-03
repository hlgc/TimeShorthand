//
//  TSLoginContentView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/3.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSLoginContentView.h"

@interface TSLoginContentView ()



@end

@implementation TSLoginContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    REGISTER_NOTIFY(UITextFieldTextDidChangeNotification, @selector(textFieldDidChangeNoti:));
    return self;
}

#pragma mark - Private
/// 控制登陆按钮是否能够点击
- (void)loginBtnEnable {
    if (_passwordTextField.text.length >= 6 &&
        _usernameTextField.text.length >= 6) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

- (void)textFieldDidChangeNoti:(NSNotification *)noti {
//    [self loginBtnEnable];
}

- (void)onTouchLoginButton:(UIButton *)button {
    [self endEditing:YES];
    if (self.usernameTextField.text.length < 6) {
        [LHHudTool showErrorWithMessage:@"please enter at least 6 accounts."];
        return;
    } else if (self.passwordTextField.text.length < 6) {
        [LHHudTool showErrorWithMessage:@"please enter at least 6 passwords."];
        return;
    }
    SAFE_BLOCK(self.didClickLoginButton, self.usernameTextField.text, self.passwordTextField.text);
}

#pragma mark Add
- (void)addConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(30.0f);
    }];
    
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(52.0f);
        make.right.equalTo(self).offset(-30.0f);
        make.height.equalTo(@44.0f);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30.0f);
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(24.0f);
        make.right.equalTo(self).offset(-30.0f);
        make.height.equalTo(@44.0f);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(54.0f);
        make.height.equalTo(@44.0f);
        make.left.equalTo(self).offset(30.0f);
        make.right.equalTo(self).offset(-30.0f);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loginButton);
    }];
}

- (void)addSubviews {
    [self addTitleLabel];
    [self addUsernameTextField];
    [self addPasswordTextField];
    [self addLoginButton];
}

- (void)addTitleLabel {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont pf_PingFangSC_RegularWithSize:30.0f];
    _titleLabel.textColor = [UIColor pf_colorWithHex:0x354048];
    _titleLabel.text = @"Sign in";
    [self addSubview:_titleLabel];
}

- (void)addUsernameTextField {
    _usernameTextField = [[TSLoginTextField alloc] initWithLeftImageName:@"login_username"];
    _usernameTextField.font = [UIFont pf_PingFangSC_LightWithSize:12.0f];
    _usernameTextField.placeholder = @"Please enter a username (at least 6 bits)";
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    [self addSubview:_usernameTextField];
}

- (void)addPasswordTextField {
    _passwordTextField = [[TSLoginTextField alloc] initWithLeftImageName:@"login_password"];
    _passwordTextField.font = [UIFont pf_PingFangSC_LightWithSize:12.0f];
    _passwordTextField.placeholder = @"Please enter your password (at least 6 bits)";
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    [self addSubview:_passwordTextField];
}

- (void)addLoginButton {
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _loginButton.enabled = NO;
    _loginButton.size = CGSizeMake(SCREEN_WIDTH - 60.0f, 44.0f);
    _loginButton.layer.cornerRadius = 22.0f;
    _loginButton.clipsToBounds = YES;
    _loginButton.titleLabel.font = [UIFont pf_PingFangSC_RegularWithSize:16.0f];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor pf_colorWithHex:0xECD464]] forState:UIControlStateNormal];
    [_loginButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(onTouchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginButton];
}

@end
