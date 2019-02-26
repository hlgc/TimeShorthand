//
//  PFActionSheet.m
//  PetFriend
//
//  Created by liuhao on 2018/12/18.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "PFActionSheet.h"

static CGFloat kItemRowHeight = 50.0f;

@interface PFActionSheet ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSMutableArray <UIButton *>*itemButtons;
@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) PFActionSheetwDidClickItemBlock didClickItemBlock;

@end

@implementation PFActionSheet

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    lh_animations(^{
        self.blackView.alpha = .5f;
        self.contentView.bottom = self.bottom;
    }, nil);
}

- (void)dismiss:(PFVoidBlock)complete {
    lh_animations(^{
        self.blackView.alpha = .0f;
        self.contentView.top = self.height;
    }, ^{
        [self removeFromSuperview];
        SAFE_BLOCK(complete);
    });
}

- (instancetype)initWithMessage:(NSString*)message alertBlock:(PFActionSheetwDidClickItemBlock)alertBlock cancelTitle:(NSString*)cancelTitle otherTitles:(NSString*)otherTitles, ...  NS_REQUIRES_NIL_TERMINATION {
    self = [super initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    if (!self) {
        return nil;
    }
    [self addMessageLabelWithTitle:message];
    _didClickItemBlock = alertBlock;
    
    NSMutableArray *tempOtherTitles = @[].mutableCopy;
    if (otherTitles) {
        va_list argList;
        [tempOtherTitles addObject:otherTitles];
        va_start(argList, otherTitles);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [tempOtherTitles addObject:arg];
        }
    }
    
    if (cancelTitle) {
        [tempOtherTitles addObject:cancelTitle];
    }
    
    self.titles = tempOtherTitles.copy;
    [self setupUI];
    return self;
}

#pragma mark - Touch
- (void)onTouchTitleButton:(UIButton *)button {
    [self dismiss:^{
        if (button.tag == self.titles.count - 1) {
            return;
        }
        SAFE_BLOCK(self.didClickItemBlock, button.tag);
    }];
}

- (void)onTouchBlackView {
    [self dismiss:nil];
}

#pragma mark - Private

- (void)setTitles:(NSArray *)titles {
    if (!titles.count) {
        titles = @[@"取消"];
    }
    __block UIButton *lastBtn = nil;
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onTouchTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = idx;
        button.titleLabel.font = FONT_SYSTEM_17;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
        if (idx == titles.count - 1) {
            //最后一个是橙色,其余灰色
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
    _contentView.width = self.width;
    _contentView.top = self.bottom;
    __block UIButton *lastBtn = nil;
    [self.itemButtons enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kItemRowHeight));
            make.width.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            if (idx) {
                make.top.equalTo(lastBtn.mas_bottom);
            } else if (self->_messageLabel) {
                make.top.equalTo(self->_messageLabel.mas_bottom).offset(30.0f);
            } else {
                make.top.equalTo(self.contentView);
            }
        }];
        if (lastBtn && idx-1 <= self.lines.count - 1) {
            [self.lines[idx-1] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn.mas_bottom);
                make.left.right.equalTo(self.contentView);
                if (idx - 1 == self.lines.count - 1) {
                    make.height.equalTo(@6.f);
                } else {
                    make.height.equalTo(@.5f);
                }
            }];
            lastBtn = btn;
        }
        if (!lastBtn) {
            lastBtn = btn;
        }
    }];
    
    [self layoutIfNeeded];
    
    _contentView.height = self.itemButtons.lastObject.bottom + [UIView safeAreaBottom];
}

- (void)addSubviews {
    [self addBlackView];
    [self addContentView];
}

- (void)addBlackView {
    _blackView = [[UIView alloc] initWithFrame:self.frame];
    [_blackView setBackgroundColor:[UIColor blackColor]];
    _blackView.alpha = .0f;
    [_blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchBlackView)]];
    [self addSubview:_blackView];
}

- (void)addContentView {
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
}

- (void)addMessageLabelWithTitle:(NSString *)title {
    if (!title.length) {
        return;
    }
    _messageLabel = [UILabel new];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = FONT_SYSTEM_15;
    _messageLabel.textColor = COLOR_FONT_GREY;
    _messageLabel.text = title;
    [self.contentView addSubview:_messageLabel];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kGallopItemMargin);
        make.right.equalTo(self.contentView).offset(-kGallopItemMargin);
        make.top.equalTo(self.contentView).offset(kGallopItemMargin);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE_GREY;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@.5f);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(kGallopItemMargin);
    }];
}

#pragma mark - Getter
- (NSMutableArray *)itemButtons {
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
