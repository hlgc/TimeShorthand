//
//  TSRecollectController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSRecollectController.h"
#import "TSLeftHeadView.h"
#import "TSRecollectHeaderView.h"
#import "TSRecollectCell.h"
#import "TSPublishController.h"

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchAdd)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TSRecollectCell" bundle:nil] forCellReuseIdentifier:TSRecollectCell.identifer];
    [self.tableView registerClass:TSRecollectHeaderView.class forHeaderFooterViewReuseIdentifier:TSRecollectHeaderView.identifer];
}

#pragma mark - Touch
- (void)onTouchAdd {
    [self presentViewController:[[TSNavigationController alloc] initWithRootViewController:[TSPublishController new]] animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSRecollectCell *cell = [tableView dequeueReusableCellWithIdentifier:TSRecollectCell.identifer];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TSRecollectHeaderView *view = [TSRecollectHeaderView viewWithTableView:tableView];
    return view;
}

- (void)setupInit {
    self.title = @"回忆录";
}

@end
