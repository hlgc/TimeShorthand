//
//  TSAlertView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSAlertView.h"
#define kTSAlertViewBgViewMaxW (SCREEN_WIDTH - 90)

@interface TSAlertView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSMutableArray <UIButton *>*itemButtons;
@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) TSAlertViewDidClickItemBlock didClickItemBlock;

@end

@implementation TSAlertView

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _contentView.bottom = .0f;
    lh_animations(^{
        self.blackView.alpha = .5f;
        self.contentView.centerY = self.centerY;
    }, nil);
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString*)message alertBlock:(TSAlertViewDidClickItemBlock)alertBlock cancelTitle:(NSString*)cancelTitle otherTitles:(NSString*)otherTitles, ... {
    self = [super initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    if (!self) {
        return nil;
    }
    _titleLabel.text = title;
    _messageLabel.text = message;
    _didClickItemBlock = alertBlock;
    
    NSMutableArray *tempOtherTitles = @[].mutableCopy;
    if (cancelTitle) {
        [tempOtherTitles addObject:cancelTitle];
    }
    
    if (otherTitles) {
        va_list argList;
        [tempOtherTitles addObject:otherTitles];
        va_start(argList, otherTitles);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [tempOtherTitles addObject:arg];
        }
    }
    
    self.titles = tempOtherTitles.copy;
    [self setupUI];
    return self;
}

#pragma mark - Touch
- (void)onTouchTitleButton:(UIButton *)button {
    lh_animations(^{
        self.blackView.alpha = .0f;
        self.contentView.top = self.height;
    }, ^{
        [self removeFromSuperview];
        SAFE_BLOCK(self.didClickItemBlock, button.tag);
    });
}

#pragma mark - Private

- (void)setTitles:(NSArray *)titles {
    if (!titles.count) {
        titles = @[@"好的"];
    }
    __block UIButton *lastBtn = nil;
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onTouchTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = idx;
        button.titleLabel.font = FONT_SYSTEM_17;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:COLOR_FONT_GREY forState:UIControlStateNormal];
        if (idx == titles.count - 1) {
            //最后一个是橙色,其余灰色
            [button setTitleColor:COLOUR_YELLOW2 forState:UIControlStateNormal];
        }
        if (lastBtn) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = COLOR_LINE_GREY;
            [self.contentView addSubview:lineView];
            [self.lines addObject:lineView];
        }
        [self.contentView addSubview:button];
        [self.itemButtons addObject:button];
        lastBtn = button;
    }];
}

#pragma mark Add
- (void)setupUI {
    [self layout];
}

- (void)layout {
    _contentView.width = kTSAlertViewBgViewMaxW;
    _contentView.center = self.center;
    
    [_titleLabel sizeToFit];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kGallopItemMargin);
        make.right.equalTo(self.contentView).offset(-kGallopItemMargin);
        make.top.equalTo(self.contentView).offset(24.0f);
    }];
    
    [_messageLabel sizeToFit];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.0f);
    }];
    
    __block UIButton *lastBtn = nil;
    CGFloat buttonWidth = kTSAlertViewBgViewMaxW / self.itemButtons.count;
    [self.itemButtons enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@57.0f);
            make.width.equalTo(@(buttonWidth));
            if (lastBtn) {
                make.left.equalTo(lastBtn.mas_right);
            } else {
                make.left.equalTo(self.contentView);
            }
            make.top.equalTo(self.messageLabel.mas_bottom).offset(20.0f);
        }];
        if (lastBtn) {
            [self.lines[idx-1] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lastBtn);
                make.left.equalTo(lastBtn.mas_right);
                make.width.equalTo(@1.0f);
                make.height.equalTo(@21.0f);
            }];
        }
        lastBtn = btn;
    }];
    
    [self layoutIfNeeded];
    
    self.contentView.height = lastBtn.bottom;
}

- (void)addSubviews {
    [self addBlackView];
    [self addContentView];
    [self addTitleLabel];
    [self addMessageLabel];
}

- (void)addBlackView {
    _blackView = [[UIView alloc] initWithFrame:self.frame];
    [_blackView setBackgroundColor:[UIColor blackColor]];
    _blackView.alpha = .0f;
    [self addSubview:_blackView];
}

- (void)addContentView {
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
}

- (void)addTitleLabel {
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FONT_BOLD_18;
    _titleLabel.textColor = COLOR_FONT_BLACK;
    [self.contentView addSubview:_titleLabel];
}

- (void)addMessageLabel {
    _messageLabel = [UILabel new];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = FONT_SYSTEM_15;
    _messageLabel.textColor = COLOR_FONT_GREY;
    [self.contentView addSubview:_messageLabel];
}

#pragma mark - Getter
- (NSMutableArray <UIButton *>*)itemButtons {
    if (_itemButtons) {
        return _itemButtons;
    }
    _itemButtons = @[].mutableCopy;
    return _itemButtons;
}

- (NSMutableArray *)lines {
    if (_lines) {
        return _lines;
    }
    _lines = @[].mutableCopy;
    return _lines;
}

@end
