//
//  TSTools.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/23.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTools.h"
#import "sys/utsname.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

@implementation TSTools

+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo saveBlock:(LHSavePhotoBlock)block {
    if (!photo) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            block(400, @"没有权限");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!iOS9_Later) {
                UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
                block(200, @"保存成功");
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                if (@available(iOS 9.0, *)) {
                    createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:photo].placeholderForCreatedAsset;
                }
            } error:&error];
            
            if (error) {
                block(400, @"保存失败");
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self createCollection:albumName];
            if (collection == nil) {
                block(400, @"保存失败");
                return;
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                block(400, @"保存失败");
            } else {
                block(200, @"保存成功");
            }
        });
    }];
}

// 创建自己要创建的自定义相册
+ (PHAssetCollection * )createCollection:(NSString *)albumName {
    NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection * createCollection = nil;
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        
        NSError * error1 = nil;
        __block NSString * createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error1];
        
        if (error1) {
           NSLog(@"创建相册失败...");
            return nil;
        }
        // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    
    return createCollection;
}
    
+ (NSString *)getCacheFolder {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}
    
+ (NSString *)getCurrentUserCacheFolderWithFolderName:(NSString *)folderName {
    NSString *cacheFile = [self getCacheFolder];
    NSString *dirPath = [cacheFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@", [[NSBundle mainBundle] bundleIdentifier], [TSUserTool sharedInstance].user.username, folderName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL isDirExist = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!isDirExist) {
        NSLog(@"Resource 文件夹不存在，需要创建文件夹！");
        isDirExist = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (isDirExist) {
        // NSLog(@"文件夹之前就存在或者文件夹这次创建成功都会返回文件全路径！");
        return dirPath;
    }
    return nil;
}

@end
