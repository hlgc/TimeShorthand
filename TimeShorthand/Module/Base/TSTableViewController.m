//
//  TSTableViewController.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSTableViewController.h" 
#import "TSTableViewHeaderFooterView.h"

@interface TSTableViewController ()

@end

@implementation TSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupInit {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:TSTableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:TSTableViewHeaderFooterView.identifer];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TSTableViewCell cellWithTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .0000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .00000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [TSTableViewHeaderFooterView viewWithTableView:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [TSTableViewHeaderFooterView viewWithTableView:tableView];
}

#pragma mark - Getter
- (NSMutableArray *)datas {
    if (_datas) {
        return _datas;
    }
    _datas = @[].mutableCopy;
    return _datas;
}

@end
