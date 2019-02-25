//
//  TSSettingController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSSettingController.h"
#import "TSNotiSwitchView.h"
#import "TSPersonalCenterCell.h"

@interface TSSettingController ()

@property (nonatomic, strong) TSNotiSwitchView *headerView;

@end

@implementation TSSettingController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSPersonalCenterCell" bundle:nil] forCellReuseIdentifier:TSPersonalCenterCell.identifer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerView reloadData];
}

- (void)setupInit {
    self.title = @"设置";
    self.tableView.tableHeaderView = self.headerView;
}

- (TSNotiSwitchView *)headerView {
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[TSNotiSwitchView alloc] init];
    return _headerView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[TSPersonalCenterCell identifer]];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSMutableArray *)datas {
    NSMutableArray *tempDatas = [super datas];
    if (tempDatas.count) {
        return tempDatas;
    }
    TSCommonModel *model1 = [TSCommonModel new];
    model1.title = @"设置生日";
    
    TSCommonModel *model2 = [TSCommonModel new];
    model2.title = @"预设寿命";
    
    [tempDatas addObjectsFromArray:@[model1, model2]];
    return tempDatas;
}

@end
