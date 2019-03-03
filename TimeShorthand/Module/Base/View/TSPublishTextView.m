
//
//  TSPublishTextView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSPublishTextView.h"
#import "NSMutableAttributedString+Chain.h"

static NSInteger const kMaxContentCount = 1000;

@interface TSPublishTextView () <UITextViewDelegate> {
    NSString *_text;
    NSInteger _maxContentCount;
}

@end

@implementation TSPublishTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat promptLabelH = 18.0f;
    _promptLabel.size = CGSizeMake(self.width, promptLabelH);
    
    _textView.frame = CGRectMake(0, 0, self.width, self.height - _promptLabel.height);
    
    [_placeHolder sizeToFit];
    _placeHolder.width = _textView.width;
    _placeHolder.left = 6.0f;
    
    
    _promptLabel.top = _textView.bottom;
}

- (BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

- (void)setupUI {
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont pf_PingFangSC_RegularWithSize:15.0f];
    _textView.textColor = [UIColor pf_colorWithHex:0x303233];
    _textView.delegate = self;
    _textView.textContainerInset = UIEdgeInsetsMake(.0f, .0f, .0f, .0f);
    
    _placeHolder = [[UILabel alloc] init];
    _placeHolder.font = [UIFont pf_PingFangSC_RegularWithSize:15.0f];
    _placeHolder.numberOfLines = 0;
    _placeHolder.text = @"Tell me what you think...";
    _placeHolder.textColor = [UIColor pf_colorWithHex:0x929292];
    [_textView addSubview:_placeHolder];
    [self addSubview:_textView];
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.text = [NSString stringWithFormat:@"0/%zd", kMaxContentCount];
    _promptLabel.textAlignment = NSTextAlignmentRight;
    _promptLabel.font = [UIFont pf_PingFangSC_RegularWithSize:12.0f];
    _promptLabel.textColor = [UIColor pf_colorWithHex:0xBCBCBC];
    [self addSubview:_promptLabel];
}

#pragma mark - Delegate
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // 字数限制操作
    if (textView.text.length > self.maxContentCount) {
        SAFE_BLOCK(self.textDidChangeMaxBlock);
        textView.text = [textView.text substringToIndex:self.maxContentCount];
    }
    SAFE_BLOCK(self.textDidChange, textView.text);
    _promptLabel.attributedText = [[NSMutableAttributedString pf_makeAttributedString:[NSString stringWithFormat:@"%zd", textView.text.length] attributes:^(NSMutableDictionary *make) {
        UIColor *color = [UIColor pf_colorWithHex:0xBCBCBC];
        if (textView.text.length) {
            color = [UIColor pf_colorWithHex:0xD7AB70];
        }
        make.pf_color(color).pf_font(self->_promptLabel.font);
    }] pf_addAttributedString:[NSString stringWithFormat:@"/%zd", self.maxContentCount] attributes:^(NSMutableDictionary *make) {
        make.pf_color([UIColor pf_colorWithHex:0xBCBCBC]).pf_font(self->_promptLabel.font);
    }];
    
    if (textView.text.length) {
        _placeHolder.alpha = .0f;
        return;
    }
    _placeHolder.alpha = 1.0f;
}

#pragma mark - Getter && Setter
- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    [self textViewDidChange:self.textView];
}

- (NSInteger)maxContentCount {
    if (_maxContentCount > 0) {
        return _maxContentCount;
    }
    return kMaxContentCount;
}

- (void)setMaxContentCount:(NSInteger)maxContentCount {
    if (maxContentCount <= 0) {
        return;
    }
    _maxContentCount = maxContentCount;
    _promptLabel.text = [NSString stringWithFormat:@"0/%zd", maxContentCount];
}

@end
