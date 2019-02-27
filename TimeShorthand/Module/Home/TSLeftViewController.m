//
//  TSLeftViewController.m
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSLeftViewController.h"
#import "TSLeftHeadView.h"
#import "TSLeftItemCell.h"
#import "TSPersonalCenterController.h"
#import "UIViewController+MMDrawerController.h"
#import "TSSettingController.h"
#import "TSRecollectController.h"

@interface TSLeftViewController ()

@property (nonatomic, strong) TSLeftHeadView *headView;

@end

@implementation TSLeftViewController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TSLeftItemCell" bundle:nil] forCellReuseIdentifier:TSLeftItemCell.identifer];
    
    _headView = [TSLeftHeadView viewFromXib];
    _headView.height = 180.0f;
    _headView.clipsToBounds = YES;
    self.tableView.tableHeaderView = _headView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_headView loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.tableViewTop.constant = [UIView safeAreaTop];
//    self.tableViewBottom.constant = [UIView safeAreaBottom];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSLeftItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[TSLeftItemCell identifer]];
    cell.model = self.datas[indexPath.row];
    cell.didClickItemCellBlock = ^(TSCommonModel * _Nonnull model) {
        UIViewController *showVC = nil;
        switch (indexPath.row) {
            case 0: {
                showVC = [TSPersonalCenterController new];
                break;
            }
            case 1: {
                showVC = [TSRecollectController new];
                break;
            }
            default: {
                showVC = [TSSettingController new];
                break;
            }
        }
        
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:showVC animated:NO];
        //当我们push成功之后，关闭我们的抽屉
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)datas {
    NSMutableArray *tempDatas = [super datas];
    if (tempDatas.count) {
        return tempDatas;
    }
    TSCommonModel *model1 = [TSCommonModel new];
    model1.imagename = @"personal";
    model1.title = @"个人中心";
    
    TSCommonModel *model2 = [TSCommonModel new];
    model2.imagename = @"history";
    model2.title = @"回忆录";
    
    TSCommonModel *model3 = [TSCommonModel new];
    model3.imagename = @"setting";
    model3.title = @"设置";
    
    [tempDatas addObjectsFromArray:@[model1, model2, model3]];
    return tempDatas;
}

@end
