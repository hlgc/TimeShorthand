//
//  TSRecollectCell.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSTableViewCell.h"
#import "TSRecollectModel.h"

@interface TSRecollectCell : TSTableViewCell

@property (nonatomic, strong) TSRecollectModel *model;
@property (nonatomic, assign) CGFloat cellHeight;

@end
