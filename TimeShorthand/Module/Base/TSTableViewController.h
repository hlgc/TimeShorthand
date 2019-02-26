//
//  TSTableViewController.h
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSViewController.h"
#import "TSTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSInteger, PFTableNodeControllerRefreshStyle) {
    PFTableNodeControllerRefreshStyleHeader,
    PFTableNodeControllerRefreshStyleFooter
};

@interface TSTableViewController : TSViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (nonatomic, strong) NSMutableArray *datas;

/// 下拉上拉
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BOOL refreshHeader;
@property (nonatomic, assign) BOOL refreshFooter;


@property (nonatomic, strong, readonly) MJRefreshGifHeader *gifHeader;
@property (nonatomic, strong, readonly) MJRefreshAutoGifFooter *gifFooter;

/// 加载方法
- (void)headerRefreshing;
- (void)footerRefreshing;

- (void)endRefreshingWithStyle:(PFTableNodeControllerRefreshStyle)style;
- (void)beginRefreshing;
- (void)endRefreshingWithNoMoreData;
- (void)resetNoMoreData;

- (void)setDatasWithModels:(NSArray *)models;
- (void(^)(AVCloudQueryResult *result, NSError *error, PFVoidBlock complete))listCallbackWithClassname:(NSString *)classname;
- (NSArray *)modelArrayWithJson:(NSArray *)json classname:(NSString *)classname error:(NSError *)error;

@end

