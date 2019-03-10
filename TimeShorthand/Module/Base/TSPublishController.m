//
//  TSPublishController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSPublishController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TSDateTool.h"
#import "PFDatePicker.h"

static const CGFloat kPhotoViewMargin = 20.0f;

@interface TSPublishController () <HXPhotoViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TSPublishTextView *textView;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) LHPhotoManager *photoManager;
@property (nonatomic, strong) LHPhotoView *photoView;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UIButton *timeButton;

@end

@implementation TSPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self addSubViews];
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _scrollView.frame = self.view.bounds;
    _scrollView.height -= [UIView safeAreaBottom];
    
    CGFloat textViewW = self.view.width - kGallopItemMargin * 2;
    _textView.frame = CGRectMake(kGallopItemMargin, 15.0f, self.view.width - kGallopItemMargin * 2, textViewW * .46567f);
    
    [_timeButton sizeToFit];
    _timeButton.left = kGallopItemMargin;
    _timeButton.top = _textView.maxY + 20.0f;
    
    _photoView.frame = CGRectMake(20.0f, _timeButton.maxY + 20.0f, self.view.width - 40.0f, 0);
}

- (void)setupInit {
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [cancelButton setTitleColor:[UIColor pf_colorWithHex:0x999999] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onTouchCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishButton = publishButton;
    publishButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [publishButton setTitleColor:[UIColor pf_colorWithHex:0x3F7332] forState:UIControlStateNormal];
    [publishButton setTitle:@"Release" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(onTouchPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton sizeToFit];
    publishButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
}

#pragma mark - Public
- (void)postWithType:(NSInteger)type fileId:(NSArray *)fileId {
    
}

#pragma mark - Private
- (void)loadData {
}

#pragma mark - Update
#pragma mark Image

#pragma mark - Touch
- (void)onTouchTimeButton:(UIButton *)button {
    [PFDatePicker showWithTitle:@"Setting the release time" mode:PFDatePickerViewDateMode complete:^(NSString *dateStr) {
        NSDateFormatter *dateFormatter = [TSDateTool dateFormatter];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *selectDate = [dateFormatter dateFromString:dateStr];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *newDateStr = [dateFormatter stringFromDate:selectDate];
        
        [self.timeButton setTitle:[NSString stringWithFormat:@"Currently published in %@", newDateStr] forState:UIControlStateNormal];
        [self.timeButton sizeToFit];
        [self.timeButton pf_layoutButtonWithEdgeInsetsStyle:PFButtonEdgeInsetsStyleRight imageTitleSpace:0];
    }];
}

- (void)onTouchCancelClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTouchPublishButton:(UIButton *)button {
    if (!_textView.textView.text.length) {
        [LHHudTool showErrorWithMessage:@"Please enter the content~"];
        return;
    }
    [LHHudTool showLoading];
    if (self.photoManager.afterSelectedArray.count) {
        /// 有图
        //判断选中的有多少个，超过一个就是图片
        [self.photoManager.afterSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self postSinglePhotoWithModel:obj];
        }];
        return;
    }
    [self _publish];
}

- (void)updateImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, .3f);
    AVFile *file = [AVFile fileWithData:imageData name:@"recollect.png"];
    
    [file uploadWithCompletionHandler:^(BOOL succeeded, NSError *error) {
        if (error || !succeeded) {
            
            return ;
        }
        NSLog(@"%@", file.url);
        [self.images addObject:file.url];
        if (self.photoManager.afterSelectedArray.count == self.images.count) {
            /// 发布
            [self _publish];
        }
    }];
}

- (void)_publish {
    AVObject *recollect = [AVObject objectWithClassName:@"Recollect"];
    [recollect setObject:self.textView.textView.text forKey:@"content"];
    [recollect setObject:self.images.copy forKey:@"images"];
    
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [_timeButton titleForState:UIControlStateNormal];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Currently published in " withString:@""];
    NSDate *selectDate = [df dateFromString:dateString];
    [recollect setObject:[NSString stringWithFormat:@"%.0f", [selectDate timeIntervalSince1970]] forKey:@"time"];
    [recollect setObject:[AVUser currentUser].username forKey:@"user"];
    [recollect saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [LHHudTool showErrorWithMessage:error.localizedFailureReason ? : kServiceErrorString];
            return;
        }
        // 存储成功
        [LHHudTool showSuccessWithMessage:@"Released success"];
        SAFE_BLOCK(self.didPublishCompeleteBlock);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark Images
- (void)postSinglePhotoWithModel:(HXPhotoModel *)selectedModel {
    LHWeakSelf
    if (selectedModel.asset) {
        PHImageRequestOptions*options = [[PHImageRequestOptions alloc]init];
        options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageDataForAsset:selectedModel.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [weakSelf updateImage:[UIImage imageWithData:imageData]];
        }];
    } else {
        UIImage *image = selectedModel.thumbPhoto;
        if (selectedModel.previewPhoto) {
            image = selectedModel.previewPhoto;
        }
        [weakSelf updateImage:image];
    }
}

#pragma mark - Delegate
#pragma mark UIimagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXPhotoModel *model;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        model = [HXPhotoModel photoModelWithImage:image];
        if (self.photoManager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.photoManager.configuration.customAlbumName photo:model.thumbPhoto];
        }
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        model = [HXPhotoModel photoModelWithVideoURL:url videoTime:second];
        if (self.photoManager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.photoManager.configuration.customAlbumName videoURL:url];
        }
    }
    if (self.photoManager.configuration.useCameraComplete) {
        self.photoManager.configuration.useCameraComplete(model);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSLog(@"所有:%zd - 照片:%zd - 视频:%zd",allList.count,photos.count,videos.count);
    NSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
    
    //    [HXPhotoTools selectListWriteToTempPath:allList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
    //        LHLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);
    //    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
    //        LHLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
    //    } error:^{
    //        LHLog(@"失败");
    //    }];
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSLog(@"%@ --> index - %zd",model,index);
}

#pragma mark Add
- (void)addSubViews {
    [self addScrollView];
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    [self addTextView];
    [self addTimeButton];
    [self addPhotoView];
}



- (void)addTextView {
    _textView = [[TSPublishTextView alloc] init];
    //    _textView.font = LHFont16;
    //    _textView.placehText = @"说说你的想法...";
    //    _textView.placehFont = LHFont16;
    //    _textView.placehTextColor = [UIColor lh_colorWithHex:0x929292];
    //    _textView.textContainerInset = UIEdgeInsetsMake(.0f, 0.0f, 26.0f, 0.0f);
    //    _textView.placehLab.frame = CGRectMake(6, 2, 200, 16);
    [_scrollView addSubview:_textView];
}

- (void)addTimeButton {
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy-MM-dd"];
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_timeButton setTitle:[NSString stringWithFormat:@"Currently published in %@", [df stringFromDate:[NSDate new]]] forState:UIControlStateNormal];
    [_timeButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [_timeButton setTitleColor:[UIColor pf_colorWithHex:0x666666] forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(onTouchTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_timeButton sizeToFit];
    [_timeButton pf_layoutButtonWithEdgeInsetsStyle:PFButtonEdgeInsetsStyleRight imageTitleSpace:0];
    [_scrollView addSubview:_timeButton];
}

- (void)addPhotoView {
    _photoView = [LHPhotoView photoManager:self.photoManager];
    _photoView.delegate = self;
    _photoView.outerCamera = NO;
    _photoView.spacing = 5;
    _photoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_photoView];
}

#pragma mark - Getter
- (LHPhotoManager *)photoManager {
    if (_photoManager) {
        return _photoManager;
    }
    _photoManager = [[LHPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    _photoManager.selectedType = HXPhotoManagerSelectedTypePhoto;
    //    //是否打开相机
    //    _photoManager.configuration.openCamera = YES;
    //    //是否查看livePhoto
    //    _photoManager.configuration.lookLivePhoto = NO;
    //    //是否查看GIF
    //    _photoManager.configuration.lookGifPhoto = YES;
    //    //能选择的照片数量
    //    _photoManager.configuration.photoMaxNum = 9;
    //    //能选择的视频数量
    //    _photoManager.configuration.videoMaxNum = 1;
    //    // 能选择的视频加照片的总数量
    //    _photoManager.configuration.maxNum = 9;
    //    //选择的视频的最长时间
//    _photoManager.configuration.videoMaxDuration = MAXFLOAT;
    //    //保存到系统相册
    //    _photoManager.configuration.saveSystemAblum = YES;
    //    //照片列表按日期倒序 默认 NO
    //    _photoManager.configuration.reverseDate = YES;
    //    //照片是否可以编辑   default YES
    //    _photoManager.configuration.photoCanEdit = NO;
    //    //视频是否可以编辑   default YES
    //    _photoManager.configuration.videoCanEdit = NO;
    //    //单选模式下选择图片时是否直接跳转到编辑界面  - 默认 YES
    //    _photoManager.configuration.singleJumpEdit = NO;
    //    // 是否需要显示日期section  默认YES
    //    _photoManager.configuration.showDateSectionHeader = NO;
    //    // 图片和视频是否能够同时选择 默认支持
    //    _photoManager.configuration.selectTogether = NO;
    //    // 相册列表每行多少个照片 默认4个 iphone 4s / 5  默认3个
    //    //        _photoManager.configuration.rowCount = 3;
    //    _photoManager.configuration.movableCropBox = NO;
    //    //是否过滤iCloud上的资源 默认NO
    //    _photoManager.configuration.filtrationICloudAsset = YES;
    //    //是否下载iCloud上的资源
    //    _photoManager.configuration.downloadICloudAsset = NO;
    //    // 是否可移动的裁剪框
    //    //        _photoManager.configuration.movableCropBoxEditSize = YES;
    //    // 可移动裁剪框的比例 (w,h)
    //    //        一定要是宽比高哦!!!
    //    //        当 movableCropBox = YES && movableCropBoxEditSize = YES
    //    //        如果不设置比例即可自由编辑大小
    //    //        _photoManager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
    //
    //    __weak typeof(self) weakSelf = self;
    //    //        _photoManager.configuration.replaceCameraViewController = YES;
    //    _photoManager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
    //
    //        // 这里使用系统相机
    //        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //        imagePickerController.delegate = (id)weakSelf;
    //        imagePickerController.allowsEditing = NO;
    //        NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
    //        NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
    //        NSArray *arrMediaTypes;
    //        if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
    //            arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
    //        }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
    //            arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
    //        }else {
    //            arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
    //        }
    //        [imagePickerController setMediaTypes:arrMediaTypes];
    //        // 设置录制视频的质量
    //        [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
    //        //设置最长摄像时间
    //        [imagePickerController setVideoMaximumDuration:60.f];
    //        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //        imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //        imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //        [viewController presentViewController:imagePickerController animated:YES completion:nil];
    //    };
    return _photoManager;
}

- (NSMutableArray *)images {
    if (_images) {
        return _images;
    }
    _images = @[].mutableCopy;
    return _images;
}

@end
