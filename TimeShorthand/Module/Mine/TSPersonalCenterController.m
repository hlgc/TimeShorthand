//
//  TSPersonalCenterController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/24.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSPersonalCenterController.h"
#import "TSPersonalCenterCell.h"

@interface TSPersonalCenterController ()

@end

@implementation TSPersonalCenterController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self.tableView registerNib:[UINib nibWithNibName:@"TSPersonalCenterCell" bundle:nil] forCellReuseIdentifier:TSPersonalCenterCell.identifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSPersonalCenterCell" bundle:nil] forCellReuseIdentifier:@"header"];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[TSPersonalCenterCell identifer]];
    if (!indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
    }
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 80.0f;
    }
    return 60.0f;
}

- (NSMutableArray *)datas {
    NSMutableArray *tempDatas = [super datas];
    if (tempDatas.count) {
        return tempDatas;
    }
    TSCommonModel *model1 = [TSCommonModel new];
    model1.imagename = @"头像url";
    model1.title = @"头像";
    
    TSCommonModel *model2 = [TSCommonModel new];
    model2.title = @"昵称";
    model2.subTitle = @"哈哈哟哟";
    
    TSCommonModel *model3 = [TSCommonModel new];
    model3.title = @"性别";
    model3.subTitle = @"男";
    
    TSCommonModel *model4 = [TSCommonModel new];
    model4.title = @"出生日期";
    model4.subTitle = @"2018-8-21";
    
    TSCommonModel *model5 = [TSCommonModel new];
    model5.title = @"寿命预测";
    model5.subTitle = @"100";
    
    [tempDatas addObjectsFromArray:@[model1, model2, model3, model4, model5]];
    return tempDatas;
}

@end
