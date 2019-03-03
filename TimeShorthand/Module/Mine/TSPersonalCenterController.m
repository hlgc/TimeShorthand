//
//  TSPersonalCenterController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/24.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSPersonalCenterController.h"
#import "TSPersonalCenterCell.h"
#import "PFActionSheet.h"
#import "HXPhotoPicker.h"
#import "TSDateTool.h"
#import "TSSetPropertyController.h"

@interface TSPersonalCenterController () <HXAlbumListViewControllerDelegate, HXCustomCameraViewControllerDelegate>

@property (nonatomic, copy) NSString *avatarUrl;

@end

@implementation TSPersonalCenterController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Personal Center";
    [self.tableView registerNib:[UINib nibWithNibName:@"TSPersonalCenterCell" bundle:nil] forCellReuseIdentifier:TSPersonalCenterCell.identifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSPersonalCenterCell" bundle:nil] forCellReuseIdentifier:@"header"];
}

#pragma mark - Private
- (void)updateImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, .3f);
    AVFile *file = [AVFile fileWithData:imageData name:@"avatar.png"];
    [LHHudTool showLoading];
    [file uploadWithCompletionHandler:^(BOOL succeeded, NSError *error) {
        TSUser *user = [TSUserTool sharedInstance].user;
        user.headUrl = file.url;
        AVUser *currentUser = [AVUser currentUser];
        [currentUser setObject:file.url forKey:@"headUrl"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [LHHudTool showErrorWithMessage:error.localizedFailureReason ? : kServiceErrorString];
                return;
            }
            // 存储成功
            [LHHudTool showSuccessWithMessage:@"Save success"];
            TSCommonModel *model = self.datas.firstObject;
            model.imagename = file.url;
            [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}

// 裁剪头像
- (void)cropImage:(UIImage *)porImage {
    [self updateImage:porImage];
    //    LHPortraitCropView *cropView = [[LHPortraitCropView alloc] initWithImage:porImage size:CGSizeMake(ScreenWidth - 50,ScreenWidth - 50)];
    //    [cropView show];
    //    LHWeakSelf
    //    cropView.finishedClippingImageBlock = ^(UIImage *image) { LHSelf
    //
    //        // 记录选择了头像
    //        self.isSelectAvatarImage = YES;
    //
    //        self.iconView.iconImageView.image = image;
    //    };
}

/**
 前往相机
 */
- (void)goCameraViewController {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [self.view showImageHUDText:[NSBundle hx_localizedStringForKey:@"无法使用相机!"]];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:0];
                if (manager.configuration.replaceCameraViewController) {
                    HXPhotoConfigurationCameraType cameraType;
                    cameraType = HXPhotoConfigurationCameraTypePhoto;
                    manager.configuration.shouldUseCamera(weakSelf, cameraType, manager);
                    manager.configuration.useCameraComplete = ^(HXPhotoModel *model) {
                        
                    };
                    return;
                }
                HXCustomCameraViewController *vc = [[HXCustomCameraViewController alloc] init];
                vc.delegate = weakSelf;
                vc.manager = manager;
                vc.isOutside = YES;
                HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
                nav.isCamera = YES;
                nav.supportRotation = manager.configuration.supportRotation;
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle hx_localizedStringForKey:@"Cannot use camera"] message:[NSBundle hx_localizedStringForKey:@"Please allow access to the camera in Settings-Privacy-Camera"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"Cacel"] style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"Set up"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
}

#pragma mark - HXAlbumListViewControllerDelegate
/**
 从相册获取照片
 
 @param albumListViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    
    if (!photoList.count) {
        return;
    }
    HXPhotoModel *model = photoList.firstObject;
    if (!model) {
        return;
    }
    // 获取原图
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:model.imageSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self updateImage:result];
    }];
}

#pragma mark - HXCustomCameraViewControllerDelegate
// 拍照获取到照片
- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    [self cropImage:model.previewPhoto];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[TSPersonalCenterCell identifer]];
    if (!indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
    }
    cell.model = self.datas[indexPath.row];
    cell.didClickSelfBlock = ^{
        if (indexPath.row) {
            [self presentViewController:[TSSetPropertyController new] animated:YES completion:nil];
            return ;
        }
        [[[PFActionSheet alloc] initWithMessage:nil alertBlock:^(NSInteger index) {
            switch (index) {
                case 0: {
                    // 相册
                    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
                    // 是否打开相机
                    manager.configuration.openCamera = NO;
                    // 是否为单选模式
                    manager.configuration.singleSelected = YES;
                    // 单选模式下选择图片时是否直接跳转到编辑界面
                    manager.configuration.singleJumpEdit = NO;
                    // 照片是否可以编辑
                    manager.configuration.photoCanEdit = NO;
                    // 是否支持旋转
                    manager.configuration.supportRotation = NO;
                    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
                    vc.manager = manager;
                    vc.delegate = self;
                    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
                    nav.supportRotation = manager.configuration.supportRotation;
                    [self presentViewController:nav animated:YES completion:nil];
                    break;
                }
                case 1:
                    /// 拍照
                    [self goCameraViewController];
                    break;
                default:
                    break;
            }
        } cancelTitle:@"Cancel" otherTitles:@"Album", @"Photograph", nil] show];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 80.0f;
    }
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)datas {
    NSMutableArray *tempDatas = [super datas];
    if (tempDatas.count) {
        return tempDatas;
    }
    TSUser *user = TSUserTool.sharedInstance.user;
    
    TSCommonModel *model1 = [TSCommonModel new];
    model1.imagename = user.headUrl?:@"123";
    model1.title = @"Head";
    
    TSCommonModel *model2 = [TSCommonModel new];
    model2.title = @"Nickname";
    model2.subTitle = user.name;
    
//    TSCommonModel *model3 = [TSCommonModel new];
//    model3.title = @"性别";
//    model3.subTitle = @"男";
    
    NSDateFormatter *df = [TSDateTool dateFormatter];
    df.dateFormat = @"yyyy-MM-dd";
    TSCommonModel *model4 = [TSCommonModel new];
    model4.title = @"Birth";
    model4.subTitle = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:user.birthday.integerValue]];
    
    TSCommonModel *model5 = [TSCommonModel new];
    model5.title = @"Life prediction";
    model5.subTitle = user.life;
    
    [tempDatas addObjectsFromArray:@[model1, model2, model4, model5]];
    return tempDatas;
}

@end
