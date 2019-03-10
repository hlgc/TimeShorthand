//
//  TSTargetController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTargetController.h"
#import "TSAddTargetController.h"
#import "TSNotDataView.h"
#import "TSTargetTableViewCell.h"

@interface TSTargetController ()

@property (nonatomic, strong) TSNotDataView *notView;
@property (nonatomic, copy) NSString *fileName;

@end

@implementation TSTargetController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Target Manage";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_t"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchAdd)];
    [self settingNotView];
    
    [self.tableView registerNib:[UINib nibWithNibName:TSTargetTableViewCell.identifer bundle:nil] forCellReuseIdentifier:TSTargetTableViewCell.identifer];
}

- (void)settingNotView {
    if (!self.datas.count && !_notView.superview) {
        [self.view addSubview:self.notView];
    } else {
        [_notView removeFromSuperview];
    }
}

- (void)onTouchAdd {
    TSAddTargetController *v = [TSAddTargetController new];
    v.didCompleteBlock = ^(TSTargetModel * _Nonnull model) {
        [self.datas addObject:model];
        [self settingNotView];
        [[self.datas modelToJSONObject] writeToFile:self.fileName atomically:NO];
        [self.tableView reloadData];
    };
    [self presentViewController:[[TSNavigationController alloc] initWithRootViewController:v] animated:YES completion:nil];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSTargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TSTargetTableViewCell.identifer];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSTargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TSTargetTableViewCell.identifer];
    cell.model = self.datas[indexPath.row];
    return cell.cellHeight;
}

// 编辑
- (NSArray*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    // 删除
    UITableViewRowAction *rmoveRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction*_Nonnull action, NSIndexPath*_Nonnull indexPath) {
        TSTargetModel *listModel = self.datas[indexPath.row];
        NSMutableArray *tempArr = self.datas;
        [tempArr removeObject:listModel];
        [[tempArr modelToJSONObject] writeToFile:self.fileName atomically:NO];
        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.datas.count) {
            return;
        }
        [self settingNotView];
    }];
    rmoveRowAction.backgroundColor = [UIColor redColor];
    
    TSTargetModel *listModel = self.datas[indexPath.row];
    if (listModel.state != 1) {
        // 完成
        UITableViewRowAction *completeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Completed" handler:^(UITableViewRowAction*_Nonnull action, NSIndexPath*_Nonnull indexPath) {
            TSTargetModel *listModel = self.datas[indexPath.row];
            listModel.state = 1;
            [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
            [[self.datas modelToJSONObject] writeToFile:self.fileName atomically:NO];
        }];
        completeRowAction.backgroundColor = [UIColor greenColor];
        return @[completeRowAction, rmoveRowAction];
    }
    
    return @[rmoveRowAction];
}

#pragma mark -

- (TSNotDataView *)notView {
    if (!_notView) {
        _notView = [TSNotDataView viewFromXib];
        _notView.frame = self.view.bounds;
    }
    return _notView;
}

- (NSMutableArray *)datas {
    NSMutableArray *datas = [super datas];
    if (datas.count) {
        return datas;
    }
    
    NSArray *tempArr = [NSArray arrayWithContentsOfFile:self.fileName];
    if (tempArr) {
        datas = [NSArray modelArrayWithClass:TSTargetModel.class json:tempArr].mutableCopy;
    }
    self.datas = datas;
    return datas;
}

- (NSString *)fileName {
    if (_fileName) {
        return _fileName;
    }
    _fileName = [[TSTools getCurrentUserCacheFolderWithFolderName:@"target"] stringByAppendingString:@"/target.plist"];
    return _fileName;
}

@end
