//
//  TSPublishTextView.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSPublishTextView : UIView

/// 输入框
@property (nonatomic, strong, readonly) UITextView *textView;
/// 占位文字
@property (nonatomic, strong, readonly) UILabel *placeHolder;
/// 提示
@property (nonatomic, strong, readonly) UILabel *promptLabel;
/// 最大字数, 默认1k
@property (nonatomic, assign) NSInteger maxContentCount;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) void(^textDidChange) (NSString *text);
@property (nonatomic, copy) void(^textDidChangeMaxBlock) (void);

@end
