//
//  TSRecollectController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSRecollectController.h"
#import "TSLeftHeadView.h"

@interface TSRecollectController ()

@property (nonatomic, strong) TSLeftHeadView *headView;

@end

@implementation TSRecollectController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _headView = [TSLeftHeadView viewFromXib];
    _headView.clipsToBounds = YES;
    _headView.height = 150.0f;
    self.tableView.tableHeaderView = _headView;
}

- (void)setupInit {
    self.title = @"回忆录";
}

@end
