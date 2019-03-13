//
//  TSRecollectDetailController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/3.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSRecollectDetailController.h"
#import "TSRecollectDetailCell.h"
#import "TSRecollectModel.h"
#import "PFBannerLayout.h"
#import "PFActionSheet.h"

@interface TSRecollectDetailController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testViewBottom;
@property (nonatomic, strong) UIImageView *currentImageView;

@end

@implementation TSRecollectDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.editable = NO;
    self.textView.text = self.model.content;
    
    PFBannerLayout *layout = (PFBannerLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //间距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.showsHorizontalScrollIndicator = NO;//显示水平滚动条->NO
    [self.collectionView registerNib:[UINib nibWithNibName:@"TSRecollectDetailCell" bundle:nil] forCellWithReuseIdentifier:TSRecollectDetailCell.identifer];
    self.title = @"Memoir details";
    
    self.testViewBottom.constant = [UIView safeAreaBottom];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchMenu)];
}

- (void)onTouchMenu {
    [[[PFActionSheet alloc] initWithMessage:nil alertBlock:^(NSInteger index) {
        switch (index) {
            case 0: {
                [self savePhotoToAlbum];
            }
            default:
                break;
        }
    } cancelTitle:@"Cancel" otherTitles:@"Save pictures", nil] show];
}

- (void)savePhotoToAlbum {
    //保存图片到本地
    [LHHudTool showLoadingWithMessage:@"Saving"];
    [TSTools savePhotoToCustomAlbumWithName:@"TimeShorthand" photo:self.currentImageView.image saveBlock:^(int code, NSString *message) {
        [LHHudTool hideHUD];
        if (code == 200) {
            [LHHudTool showSuccessWithMessage:message];
        } else {
            [LHHudTool showErrorWithMessage:message];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TSRecollectDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TSRecollectDetailCell.identifer forIndexPath:indexPath];
    cell.imageName = self.model.images[indexPath.row];
    self.currentImageView = cell.imageView;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth, ScreenHeight);
}

@end
