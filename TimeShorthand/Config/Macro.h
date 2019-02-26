//
//  Macro.h
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

// 版本号
#define VERSIO_NUNBER [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]

/** 定义self的弱指针 */
#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define STRONG_SELF typeof(weakSelf) self = weakSelf;
#define LHWeakSelf __weak typeof(self) weakSelf = self;
#define LHSelf typeof(weakSelf) self = weakSelf;

/*********************** 尺寸相关 ********************/
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

// 手机屏幕自动适配
//#define AUTO_FIT(float) ((SCREEN_HEIGHT < SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH) / 375.0f * float)
#define AUTO_FIT(float) float
// 安全执行Block
#define SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

/*********************** 通知(废弃, 产生依赖污染) ********************/
#define REGISTER_NOTIFY(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];
#define REGISTER_NOTIFY_OBJECT(_name, _selector, _object)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:_object];

#define NOTI_REMOVE            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define NOTI_POST(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];

/// 颜色yellow
// 主色 浅黄色
#define COLOUR_YELLOW1 [UIColor pf_colorWithHex:0xf4c500]
// 深黄色
#define COLOUR_YELLOW2 [UIColor pf_colorWithHex:0xea820f]
// 辅色 蓝色
#define COLOUR_BLUE [UIColor pf_colorWithHex:0x07a8b4]
// 点缀色 黄色
#define COLOUR_YELLOW [UIColor pf_colorWithHex:0xfda544]
// 点缀色 红色
#define COLOUR_RED [UIColor pf_colorWithHex:0xf8726f]
/// 字体黑
#define COLOR_FONT_BLACK [UIColor pf_colorWithHex:0x030303]
/// 字体灰
#define COLOR_FONT_GREY [UIColor pf_colorWithHex:0xA9A9A9]
/// 线灰
#define COLOR_LINE_GREY [UIColor pf_colorWithHex:0xEDEDED]

#define COLOR_666 [UIColor pf_colorWithHex:0x666666]
#define COLOR_0D0 [UIColor pf_colorWithHex:0x0D0D0D]
#define COLOR_BCB [UIColor pf_colorWithHex:0xBCBCBC]

/// 字体
#define FONT_SYSTEM_12 [UIFont systemFontOfSize:AUTO_FIT(12.0f)]
#define FONT_SYSTEM_14 [UIFont systemFontOfSize:AUTO_FIT(14.0f)]
#define FONT_SYSTEM_15 [UIFont systemFontOfSize:AUTO_FIT(15.0f)]
#define FONT_SYSTEM_16 [UIFont systemFontOfSize:AUTO_FIT(16.0f)]
#define FONT_SYSTEM_17 [UIFont systemFontOfSize:AUTO_FIT(17.0f)]
#define FONT_BOLD_10 [UIFont boldSystemFontOfSize:AUTO_FIT(10.0f)]
#define FONT_BOLD_12 [UIFont boldSystemFontOfSize:AUTO_FIT(12.0f)]
#define FONT_BOLD_14 [UIFont boldSystemFontOfSize:AUTO_FIT(14.0f)]
#define FONT_BOLD_16 [UIFont boldSystemFontOfSize:AUTO_FIT(16.0f)]
#define FONT_BOLD_18 [UIFont boldSystemFontOfSize:AUTO_FIT(18.0f)]
#define FONT_BOLD_20 [UIFont boldSystemFontOfSize:AUTO_FIT(20.0f)]
#define FONT_BOLD_22 [UIFont boldSystemFontOfSize:AUTO_FIT(22.0f)]
#define FONT_BOLD_25 [UIFont boldSystemFontOfSize:AUTO_FIT(25.0f)]
#define FONT_BOLD_30 [UIFont boldSystemFontOfSize:AUTO_FIT(30.0f)]

#pragma mark - 网络加载
#define SQL_SELECT_LIMIT(classname, byName, page, count) [NSString stringWithFormat:@"select * from %@ order by %@ DESC limit %zd,%zd", classname, byName, (NSInteger)page*count, (NSInteger)count]

#define SQL_SELECT_LIMIT_BY_RELEASETIME_FOR_COUNT(classname, page, count) SQL_SELECT_LIMIT(classname, @"time", page, count)

#define SQL_SELECT_LIMIT_BY_RELEASETIME_DEFAULT(classname, page) SQL_SELECT_LIMIT(classname, @"time", page, kDefaultPageCount)

#endif /* Macro_h */
