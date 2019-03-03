//
//  TSLeftHeadView.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSLeftHeadView.h"

@interface TSLeftHeadView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *subname;

@end

@implementation TSLeftHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addShadowToView:self.bgView withColor:[UIColor blackColor]];
    
    
}

- (void)loadData {
    TSUser *user = TSUserTool.sharedInstance.user;
    _username.text = user.name;
    _subname.text = user.username;
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:user.headUrl] placeholderImage:[UIImage imageNamed:@"icon-1024"]];
}


/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
}

@end
