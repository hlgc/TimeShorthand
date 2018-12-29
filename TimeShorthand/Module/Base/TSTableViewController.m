//
//  TSTableViewController.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSTableViewController.h" 

@interface TSTableViewController ()

@end

@implementation TSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableViewTop.constant = [UIView safeAreaTop];
    self.tableViewBottom.constant = [UIView safeAreaBottom];
}

- (void)setupInit {
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TSTableViewCell cellWithTableView:tableView];
}

@end
