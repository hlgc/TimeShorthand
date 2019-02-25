//
//  TSLoginController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSLoginController.h"
#import "TSLoginTextField.h"
#import "NSMutableAttributedString+Chain.h"
#import "TSAlertView.h"
#import "TSUserTool.h"
#import "AppDelegate.h"

@interface TSLoginController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TSLoginTextField *usernameTextField;
@property (nonatomic, strong) TSLoginTextField *passwordTextField;
@property (nonatomic, strong) UIButton *smsButton;

@property (nonatomic, strong) UIButton *loginButton;

/// 隐私协议
@property (nonatomic, strong) UIButton *privacyBtn;
/// 用户协议
@property (nonatomic, strong) UIButton *userProBtn;

@property (nonatomic, strong) UILabel *tipLabel;

/** 倒数秒*/
@property (nonatomic,assign) NSInteger second;
/** 定时器*/
@property (weak, nonatomic) NSTimer *timer;

@end

@implementation TSLoginController

- (void)dealloc {
    NOTI_REMOVE
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (![NSUserDefaults.standardUserDefaults boolForKey:kConsentClauseKey]) {
//        [self showAlertView];
//        return;
//    }
    [_usernameTextField becomeFirstResponder];
}

- (void)showAlertView {
    if ([NSUserDefaults.standardUserDefaults boolForKey:kConsentClauseKey]) {
        return;
    }
    [[[TSAlertView alloc] initWithTitle:@"使用须知" message:@"发布敏感和辱骂性等违规内容， 有可能面临禁言或封号\n请先阅读用户协议" alertBlock:^(NSInteger index) {
        if (index) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:kConsentClauseKey];
            /// 查看协议
            [self onTouchUserProBtn];
            return;
        }
        [self showAlertView];
    } cancelTitle:@"不同意" otherTitles:@"同意并浏览", nil] show];
}

- (void)setupInit {
    _second = 60;
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.size = CGSizeMake(44.0f, 44.0f);
//    [backBtn addTarget:self action:@selector(onTouchBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    REGISTER_NOTIFY(UITextFieldTextDidChangeNotification, @selector(textFieldDidChangeNoti:));
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)onTouchLoginButton:(UIButton *)button {
    [self.view endEditing:YES];
    [LHHudTool showLoading];
    [TSUserTool loginWithUsername:_usernameTextField.text password:_passwordTextField.text complete:^(NSError *error) {
        if (error) {
            [LHHudTool showErrorWithMessage:error.localizedFailureReason?:@"登录失败~"];
            return ;
        }
        [LHHudTool showSuccessWithMessage:@"登录成功~"];
        [self onTouchBackBtn:nil];
    }];
}

- (void)onTouchBackBtn:(UIButton *)button {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setupRootViewController];
}

//- (void)onTouchSmsButton:(UIButton *)button {
//    button.enabled = NO;
//    [_timer invalidate];
//    _timer = nil;
//
//    AVUser *user = AVUser.user;
//    user.username = @"liuhao_lc";
//    user.password = @"112233..";
//    NSError *signError = nil;
//    [LHHudTool showGIFLoading];
//    [user signUp:&signError];
//    if (signError) {
//        [LHHudTool showErrorWithMessage:signError.localizedFailureReason ? : @"登录错误"];
//        return;
//    }
//    [LHHudTool showSuccessWithMessage:@"获取成功~"];
//
//    //    [self.smsTextField becomeFirstResponder];
//    [self timer];
//    [self loginBtnEnable];
//}

- (void)onTouchPrivacyBtn {
    [LHHudTool showGIFLoading];
//    PFWebController *webViewVC = [[PFWebController alloc] initWithUrl:@"https://www.hlgc.xyz/PetFriend/protocol.html"];
//    webViewVC.title = @"隐私条款";
//    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)onTouchUserProBtn {
//    [LHHudTool showLoading];
//    PFWebController *webViewVC = [[PFWebController alloc] initWithUrl:@"https://www.hlgc.xyz/PetFriend/user/protocol.html"];
//    webViewVC.title = @"用户协议";
//    [self.navigationController pushViewController:webViewVC animated:YES];
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
    [self loginBtnEnable];
}

- (void)countDown {
    _second--;
    if(_second >= 0) {
        [self.smsButton setTitleColor:[UIColor pf_colorWithHex:0x666666] forState:UIControlStateDisabled];
        [self.smsButton setTitle:[NSString stringWithFormat:@"%zds", _second] forState:UIControlStateDisabled];
    } else {
        _second = 60;
        [_timer invalidate];
        //        self.smsButton.enabled = _phoneTextField.text.length == 11;
        [self.smsButton setTitleColor:[UIColor pf_colorWithHex:0xea820f alpha:.4f] forState:UIControlStateDisabled];
        [self.smsButton setTitle:@"重新获取" forState:UIControlStateDisabled];
        [self.smsButton setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}

#pragma mark Add
- (void)addConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80.0f + [UIView safeAreaTop]);
//        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30.0f);
    }];
    
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(52.0f);
        make.right.equalTo(self.view).offset(-30.0f);
        make.height.equalTo(@44.0f);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30.0f);
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(24.0f);
        make.right.equalTo(self.view).offset(-30.0f);
        make.height.equalTo(@44.0f);
    }];
    
    //    [_smsButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.smsTextField.mas_bottom);
    //        make.right.equalTo(self.smsTextField);
    //        make.height.equalTo(@44.0f);
    //    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view).offset(30.0f);
    }];
    
    [_userProBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipLabel);
        make.right.equalTo(self.tipLabel).offset(-14.0f);
    }];
    
    [_privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipLabel);
        make.left.equalTo(self.tipLabel.mas_right);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(54.0f);
        make.height.equalTo(@44.0f);
        make.left.equalTo(self.view).offset(30.0f);
        make.right.equalTo(self.view).offset(-30.0f);
    }];
}

- (void)addSubviews {
    [self addTitleLabel];
    [self addUsernameTextField];
    [self addPasswordTextField];
    //    [self addSmsButton];
    [self addLoginButton];
    [self addPrivacyBtn];
    [self addUserProBtn];
    [self addTipLabel];
}

- (void)addTitleLabel {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont pf_PingFangSC_RegularWithSize:30.0f];
    _titleLabel.textColor = [UIColor pf_colorWithHex:0x354048];
    _titleLabel.text = @"登录";
    [self.view addSubview:_titleLabel];
}

- (void)addUsernameTextField {
    _usernameTextField = [[TSLoginTextField alloc] initWithLeftImageName:@"login_username"];
    _usernameTextField.placeholder = @"请输入用户名";
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:_usernameTextField];
}

- (void)addPasswordTextField {
    _passwordTextField = [[TSLoginTextField alloc] initWithLeftImageName:@"login_password"];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
}

- (void)addSmsButton {
    _smsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _smsButton.enabled = NO;
    _smsButton.titleLabel.font = [UIFont pf_PingFangSC_RegularWithSize:16.0f];
    [_smsButton setTitleColor:[UIColor pf_colorWithHex:0xea820f alpha:.4f] forState:UIControlStateDisabled];
    [_smsButton setTitleColor:COLOUR_YELLOW2 forState:UIControlStateNormal];
    [_smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_smsButton addTarget:self action:@selector(onTouchSmsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smsButton];
}

- (void)addLoginButton {
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.enabled = NO;
    _loginButton.size = CGSizeMake(SCREEN_WIDTH - 60.0f, 44.0f);
    _loginButton.layer.cornerRadius = 22.0f;
    _loginButton.clipsToBounds = YES;
    _loginButton.titleLabel.font = [UIFont pf_PingFangSC_RegularWithSize:16.0f];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor pf_colorWithHex:0xECD464]] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(onTouchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

- (void)addPrivacyBtn {
    _privacyBtn = [[UIButton alloc] init];
//    _privacyBtn.titleLabel.font = FONT_SYSTEM_14;
//    [_privacyBtn setTitleColor:[UIColor pf_colorWithHex:0x587DAD] forState:UIControlStateNormal];
//    [_privacyBtn setTitle:@"隐私条款" forState:UIControlStateNormal];
//    [_privacyBtn addTarget:self action:@selector(onTouchPrivacyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_privacyBtn];
}

- (void)addUserProBtn {
    _userProBtn = [[UIButton alloc] init];
//    _userProBtn.titleLabel.font = FONT_SYSTEM_14;
//    [_userProBtn setTitleColor:[UIColor pf_colorWithHex:0x587DAD] forState:UIControlStateNormal];
//    [_userProBtn setTitle:@"用户协议" forState:UIControlStateNormal];
//    [_userProBtn addTarget:self action:@selector(onTouchUserProBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userProBtn];
}

- (void)addTipLabel {
    _tipLabel = [UILabel new];
    _tipLabel.font = FONT_SYSTEM_14;
//    _tipLabel.attributedText = [[[NSMutableAttributedString pf_makeAttributedString:@"登录注册表示同意" attributes:^(NSMutableDictionary *make) {
//        make.pf_font(FONT_SYSTEM_14).pf_color(COLOR_A6A);
//    }] pf_addAttributedString:@"用户协议" attributes:^(NSMutableDictionary *make) {
//        make.pf_font(FONT_SYSTEM_14).pf_color([UIColor clearColor]);
//    }] pf_addAttributedString:@"、" attributes:^(NSMutableDictionary *make) {
//        make.pf_font(FONT_SYSTEM_14).pf_color(COLOR_A6A);
//    }];
    [self.view addSubview:_tipLabel];
}

#pragma mark - Getter
- (NSTimer *)timer {
    if (_timer) {
        return _timer;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self countDown];
    return _timer;
}

@end
