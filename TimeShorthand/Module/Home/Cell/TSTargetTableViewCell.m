//
//  TSTargetTableViewCell.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTargetTableViewCell.h"

@interface TSTargetTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabbel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *sLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

@end

@implementation TSTargetTableViewCell

- (void)setModel:(TSTargetModel *)model {
    _model = model;
    
    switch (model.state) {
        case 0:
        case 1:
            _colorView.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            _colorView.backgroundColor = [UIColor grayColor];
            break;
        default:
            break;
    }
    
    if (model.state == 1) {
        self.completedLabel.alpha = 1.0f;
        self.sLabel.alpha = .0f;
        self.timeLabel.alpha = .0f;
        [self endTime];
    } else {
        self.completedLabel.alpha = .0f;
        self.sLabel.alpha = 1.0f;
        self.timeLabel.alpha = 1.0f;
        [self timerRun];
        [self startTime];
    }
    
    _contentLabbel.text = model.target;
    
    [self layoutIfNeeded];
    self.cellHeight = _bottomLineView.bottom;
}

- (void)startTime {
    [self endTime];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)endTime {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerRun {
    NSInteger time = self.model.time.integerValue - [[NSDate date] timeIntervalSince1970];
    if (time < 0) {
        self.model.state = 2;
        self.sLabel.textColor = self.timeLabel.textColor = self.contentLabbel.textColor = self.colorView.backgroundColor = [UIColor grayColor];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%zd", time];
}

- (void)dealloc {
    [self endTime];
    NSLog(@"%s", __func__);
}

@end
