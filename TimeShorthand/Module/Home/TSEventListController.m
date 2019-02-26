//
//  TSEventListController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSEventListController.h"
#import "TSEventListCell.h"
#import "TSDateTool.h"

@interface TSEventListController ()

@end

@implementation TSEventListController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事件";
    [self.tableView registerNib:[UINib nibWithNibName:@"TSEventListCell" bundle:nil] forCellReuseIdentifier:TSEventListCell.identifer];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSEventListCell *cell = [tableView dequeueReusableCellWithIdentifier:TSEventListCell.identifer];
    cell.model = self.datas[indexPath.row];
    cell.didClickItemCellBlock = ^(TSEventModel *model) {
        SAFE_BLOCK(self.didCompleteBlcok, model);
        [self.navigationController popViewControllerAnimated:YES];
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
    
    NSInteger count = TSUserTool.sharedInstance.user.surplusLife;
    TSEventModel *model1 = [TSEventModel new];
    model1.name = [NSString stringWithFormat:@"睡觉 %zd次", count];
    model1.selected = YES;
    
    TSEventModel *model2 = [TSEventModel new];
    model2.name = [NSString stringWithFormat:@"洗澡 %zd次", count];
    
    TSEventModel *model3 = [TSEventModel new];
    model3.name = [NSString stringWithFormat:@"旅行 %zd次", count/182];
    
    TSEventModel *model4 = [TSEventModel new];
    model4.name = [NSString stringWithFormat:@"看书 %zd次", count];
    
    TSEventModel *model5 = [TSEventModel new];
    model5.name = [NSString stringWithFormat:@"玩游戏 %zd次", count];
    
    TSEventModel *model6 = [TSEventModel new];
    model6.name = [NSString stringWithFormat:@"领工资 %zd次", count / 30];
    
    [tempDatas addObjectsFromArray:@[model1, model2, model3, model4, model5, model6]];
    return tempDatas;
}


@end