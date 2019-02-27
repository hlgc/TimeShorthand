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
#import "TSDateTool.h"

@interface TSRecollectController ()

@property (nonatomic, strong) TSLeftHeadView *headView;
@property (nonatomic, strong) NSMutableDictionary *dict;

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
    _headView.height = 240.0f;
    self.tableView.tableHeaderView = _headView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchAdd)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TSRecollectCell" bundle:nil] forCellReuseIdentifier:TSRecollectCell.identifer];
    [self.tableView registerClass:TSRecollectHeaderView.class forHeaderFooterViewReuseIdentifier:TSRecollectHeaderView.identifer];
    
    self.refreshHeader = YES;
    [self headerRefreshing];
}

#pragma mark Load
- (void)headerRefreshing {
    self.page = 0;
    [self.dict removeAllObjects];
    [self getRecollectList:^{
        [self endRefreshingWithStyle:PFTableNodeControllerRefreshStyleHeader];
        [self.tableView reloadData];
    }];
}

- (void)footerRefreshing {
    [self getRecollectList:^{
        [self.tableView reloadData];
    }];
}

- (void)getRecollectList:(PFVoidBlock)complete {
    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from Recollect order by time DESC limit %zd,%d", 5 * self.page, 5] callback:^(AVCloudQueryResult *result, NSError *error) {
        [self listCallbackWithClassname:@"TSRecollectModel"](result, error, complete);
    }];
}

- (void)setDatasWithModels:(NSArray *)models {
    [super setDatasWithModels:models];
    /// 二次重组数据, 分组
    
    [models enumerateObjectsUsingBlock:^(TSRecollectModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateFormatter *df = [TSDateTool dateFormatter];
        [df setDateFormat:@"yyyy/MM/dd"];
        NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.time.integerValue]];
        NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
        NSMutableArray *tempArr = [self.dict objectForKey:year];
        if (!tempArr) {
            tempArr = @[].mutableCopy;
        }
        [tempArr addObject:model];
        [self.dict setObject:tempArr forKey:year];
    }];
}

#pragma mark - Touch
- (void)onTouchAdd {
    [self presentViewController:[[TSNavigationController alloc] initWithRootViewController:[TSPublishController new]] animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dict.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.dict.allValues[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.dict.allValues[indexPath.section];
    TSRecollectCell *cell = [tableView dequeueReusableCellWithIdentifier:TSRecollectCell.identifer];
    cell.model = array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.dict.allValues[indexPath.section];
    TSRecollectCell *cell = [tableView dequeueReusableCellWithIdentifier:TSRecollectCell.identifer];
    cell.model = array[indexPath.row];
    return cell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TSRecollectHeaderView *view = [TSRecollectHeaderView viewWithTableView:tableView];
    view.titleLabel.text = self.dict.allKeys[section];
    return view;
}

- (void)setupInit {
    self.title = @"回忆录";
}


- (NSMutableDictionary *)dict {
    if (_dict) {
        return _dict;
    }
    _dict = @{}.mutableCopy;
    return _dict;
}

@end
