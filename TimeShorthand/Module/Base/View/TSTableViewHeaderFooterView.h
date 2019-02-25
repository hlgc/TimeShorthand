//
//  TSTableViewHeaderFooterView.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/22.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSTableViewHeaderFooterView : UITableViewHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView;
+ (instancetype)viewWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

- (void)setupInit;
- (void)addSubviews;
- (void)addConstraints;
+ (NSString *)identifer;

@end

NS_ASSUME_NONNULL_END
