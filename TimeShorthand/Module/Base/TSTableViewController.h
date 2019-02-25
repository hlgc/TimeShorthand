//
//  TSTableViewController.h
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSViewController.h"
#import "TSTableViewCell.h"

@interface TSTableViewController : TSViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (nonatomic, strong) NSMutableArray *datas;

@end

