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

- (void(^)(AVCloudQueryResult *result, NSError *error, PFVoidBlock complete))listCallbackWithClassname:(NSString *)classname {
    return ^(AVCloudQueryResult *result, NSError *error, PFVoidBlock complete) {
        if (error) {
            SAFE_BLOCK(complete);
            [LHHudTool showErrorWithMessage:error.localizedFailureReason ? : kServiceErrorString];
            return ;
        }
        NSMutableArray *tempArr = @[].mutableCopy;
        [result.results enumerateObjectsUsingBlock:^(AVObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:[obj objectForKey:kLocalDataKey]];
            [tempDict setObject:obj.objectId forKey:@"objectId"];
            [tempArr addObject:tempDict];
        }];
        NSArray *models = [NSArray modelArrayWithClass:NSClassFromString(classname) json:tempArr];
        [self setDatasWithModels:models];
        SAFE_BLOCK(complete);
    };
}

- (void)setDatasWithModels:(NSArray *)models {
    if (!self.page) {
        [self.datas removeAllObjects];
        self.refreshFooter = models.count;
    }
    if (models.count < self.pageCount) {
        [self endRefreshingWithNoMoreData];
    } else {
        [self resetNoMoreData];
    }
    [self.datas addObjectsFromArray:models];
    //    [self endRefreshing:!self.page];
    //    [self.tableNode reloadData];
    self.page++;
}

- (void)headerRefreshing {
    
}

- (void)footerRefreshing {
    
}

- (void)endRefreshingWithStyle:(PFTableNodeControllerRefreshStyle)style {
    if (style == PFTableNodeControllerRefreshStyleHeader) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)beginRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshingWithNoMoreData {
    [self endRefreshingWithStyle:PFTableNodeControllerRefreshStyleFooter];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData {
    [self endRefreshingWithStyle:PFTableNodeControllerRefreshStyleFooter];
    [self.tableView.mj_footer resetNoMoreData];
}

- (void)setRefreshHeader:(BOOL)refreshHeader {
    _refreshHeader = refreshHeader;
    if (refreshHeader) {
        self.tableView.mj_header = self.gifHeader;
    } else {
        self.tableView.mj_header = nil;
    }
}

- (void)setRefreshFooter:(BOOL)refreshFooter {
    _refreshFooter = refreshFooter;
    if (refreshFooter) {
        self.tableView.mj_footer = self.gifFooter;
    } else {
        self.tableView.mj_footer = nil;
    }
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
