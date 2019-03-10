//
//  TSTools.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/23.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LHSavePhotoBlock)( int code, NSString *message);

@interface TSTools : NSObject

+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo saveBlock:(LHSavePhotoBlock)block;
+ (NSString *)getCacheFolder;
+ (NSString *)getCurrentUserCacheFolderWithFolderName:(NSString *)folderName;
    
@end
