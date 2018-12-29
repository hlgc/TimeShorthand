//
//  TSTableViewCell.h
//  TimeShorthand
//
//  Created by liuhao on 2018/12/29.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

- (void)setupInit;
- (void)addSubviews;
- (void)addConstraints;
+ (NSString *)identifer;

@end

NS_ASSUME_NONNULL_END
