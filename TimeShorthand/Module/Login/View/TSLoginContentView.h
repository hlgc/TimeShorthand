//
//  TSLoginContentView.h
//  TimeShorthand
//
//  Created by liuhao on 2019/3/3.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSView.h"
#import "TSLoginTextField.h"

@interface TSLoginContentView : TSView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TSLoginTextField *usernameTextField;
@property (nonatomic, strong) TSLoginTextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, copy) void(^didClickLoginButton)(NSString *userName, NSString *password);

@end

