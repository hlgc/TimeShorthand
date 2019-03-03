//
//  TSRecollectDetailCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/3.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSRecollectDetailCell.h"

@interface TSRecollectDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TSRecollectDetailCell

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"icon-1024"]];
}


@end
