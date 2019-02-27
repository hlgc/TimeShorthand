//
//  TSRecollectCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSRecollectCell.h"
#import "NSMutableAttributedString+Chain.h"
#import "TSDateTool.h"

@interface TSRecollectCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end

@implementation TSRecollectCell

- (void)setModel:(TSRecollectModel *)model {
    _model = model;
    
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.time.integerValue]];
    NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(dateStr.length-2, 2)];
    
    _dateLabel.attributedText = [[NSMutableAttributedString pf_makeAttributedString:month attributes:^(NSMutableDictionary *make) {
        make.pf_font([UIFont pf_PingFangSC_RegularWithSize:28]).pf_color(COLOR_FONT_BLACK);
    }] pf_addAttributedString:day attributes:^(NSMutableDictionary *make) {
        make.pf_font([UIFont pf_PingFangSC_LightWithSize:12]).pf_color(COLOR_FONT_BLACK);
    }];
    
    _titleLabel.text = model.content;
    
    if (!model.images.count) {
        self.imageWidth.constant = .0f;
    } else {
        [_image sd_setImageWithURL:[NSURL URLWithString:model.images.firstObject] placeholderImage:[UIImage imageNamed:@"icon-1024"]];
        self.imageWidth.constant = 50.0f;
    }
}

@end
