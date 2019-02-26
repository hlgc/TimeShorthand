//
//  TSPublishController.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSViewController.h"
#import "TSNavigationController.h"
#import "TSPublishTextView.h"
#import "LHPhotoManager.h"
#import "TSAlertView.h"

@interface TSPublishController : TSViewController

@property (nonatomic, strong, readonly) LHPhotoView *photoView;
@property (nonatomic, strong, readonly) LHPhotoManager *photoManager;
@property (nonatomic, strong, readonly) TSPublishTextView *textView;

@property (nonatomic, strong, readonly) UIButton *publishButton;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, copy) void(^didPublishCompeleteBlock)(void);

- (void)setupInit;
- (void)addSubViews;
- (void)loadData;
- (void)addTextView;
/**
 发布帖子内容
 @param type 类型，0:无文件(文本) 1:音频 2:视频 3:图片
 @param fileId 文件ID
 */
- (void)postWithType:(NSInteger)type fileId:(NSArray *)fileId;

/// 上传视频
- (void)postVideoWithModel:(HXPhotoModel *)selectedModel;
/// 上传单张图片
- (void)postSinglePhotoWithModel:(HXPhotoModel *)selectedModel;
/// 上传多张图片
- (void)postImages;

#pragma mark - Touch
/// 点击取消
- (void)onTouchCancelClick:(UIButton *)button;
/// 点击发布
- (void)onTouchPublishButton:(UIButton *)button;

@end
