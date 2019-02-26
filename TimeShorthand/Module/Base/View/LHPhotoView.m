//
//  LHPhotoView.m
//  小灯塔
//
//  Created by liuhao on 2018/11/2.
//  Copyright © 2018 TheTiger. All rights reserved.
//

#import "LHPhotoView.h"
#import "PFActionSheet.h"
#import "LHPhotoManager.h"

@interface LHPhotoView ()

@end

@implementation LHPhotoView

- (instancetype)initWithManager:(HXPhotoManager *)manager {
    self = [super initWithManager:manager];
    if (!self) {
        return self;
    }
    self.previewStyle = HXPhotoViewPreViewShowStyleDark;
    self.previewShowDeleteButton = YES;
    return self;
}

/**
 添加按钮点击事件
 */
- (void)goPhotoViewController {
    [self directGoPhotoViewController];
}

- (void)goPhotoViewController:(HXPhotoManagerSelectedType)type {
    if (self.manager.type != type) {
        self.manager.type = type;
    }
    [self directGoPhotoViewController];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataList = [self valueForKey:@"dataList"];
    LHPhotoManager *manager = (LHPhotoManager *)self.manager;
    if (indexPath.item == dataList.count) {
        if ([self.delegate respondsToSelector:@selector(photoViewDidAddCellClick:)]) {
            [self.delegate photoViewDidAddCellClick:self];
        }
        if (self.didAddCellBlock) {
            self.didAddCellBlock(self);
        }
        if (self.interceptAddCellClick) {
            return;
        }
        
        // 2018/8/21 兼容打卡
        if (manager.selectedType == HXPhotoManagerSelectedTypePhotoAndVideo) {
            if (!dataList.count) {
//                PFActionSheet * mySheet = [[PFActionSheet alloc]initWithMessage:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"图片",@"视频", nil];
//                [mySheet show];
            } else {
                [self directGoPhotoViewController];
            }
            return;
        }
        [self goPhotoViewController:manager.selectedType];
        return;
    }
//    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - LHActionSheetDelegate
- (void)actionSheet:(PFActionSheet *)alertView buttonDidClickedAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 1) {
        return;
    }
    [self goPhotoViewController:buttonIndex];
}

@end
