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
#import "TSSettingLoginoutHeaderView.h"
#import "TSSetPropertyController.h"
#import "TSAlertView.h"
#import "AppDelegate.h"
#import "TSWebController.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"TSSettingLoginoutHeaderView" bundle:nil] forCellReuseIdentifier:TSSettingLoginoutHeaderView.identifer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerView reloadData];
}

- (void)setupInit {
    self.title = @"Set up";
    self.tableView.tableHeaderView = self.headerView;
}

- (TSNotiSwitchView *)headerView {
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[TSNotiSwitchView alloc] init];
    return _headerView;
}

- (void)onTouchPrivacy {
    [LHHudTool showLoading];
    TSWebController *webViewVC = [[TSWebController alloc] initWithUrl:@"https://www.hlgc.xyz/TimeShorthand/protocol.html"];
    webViewVC.title = @"Privacy clause";
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)onTouchUserPro {
    [LHHudTool showLoading];
    TSWebController *webViewVC = [[TSWebController alloc] initWithUrl:@"https://www.hlgc.xyz/TimeShorthand/user/protocol.html"];
    webViewVC.title = @"User agreement";
    [self.navigationController pushViewController:webViewVC animated:YES];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[TSPersonalCenterCell identifer]];
    cell.model = self.datas[indexPath.row];
    cell.didClickSelfBlock = ^{
        if (indexPath.row == 2) {
            // 用户
            [self onTouchUserPro];
            return ;
        } else if (indexPath.row == 3) {
            ///  隐私
            [self onTouchPrivacy];
            return;
        }
        [self presentViewController:[TSSetPropertyController new] animated:YES completion:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 64.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TSSettingLoginoutHeaderView *head = [TSSettingLoginoutHeaderView viewFromXib];
    head.didClickSelfBlock = ^{
        [[[TSAlertView alloc] initWithTitle:nil message:@"Definite exit?" alertBlock:^(NSInteger index) {
            if (!index) {
                return ;
            }
            [TSUserTool logOut];
            [((AppDelegate *)UIApplication.sharedApplication.delegate) setupRootViewController];
        } cancelTitle:@"Cacel" otherTitles:@"Sure", nil] show];
    };
    return head;
}

- (NSMutableArray *)datas {
    NSMutableArray *tempDatas = [super datas];
    if (tempDatas.count) {
        return tempDatas;
    }
    TSCommonModel *model1 = [TSCommonModel new];
    model1.title = @"Set birthday";
    
    TSCommonModel *model2 = [TSCommonModel new];
    model2.title = @"Preset life";
    
    TSCommonModel *model3 = [TSCommonModel new];
    model3.title = @"User agreement";
    
    TSCommonModel *model4 = [TSCommonModel new];
    model4.title = @"Privacy clause";
    [tempDatas addObjectsFromArray:@[model1, model2, model3, model4]];
    return tempDatas;
}

@end
