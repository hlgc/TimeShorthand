//
//  TSShareView.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/23.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSView.h"
#import "TSShareTool.h"

@interface TSShareView : TSView

+ (void)showWithComplete:(void(^)(YKShareType type))complete;

@end

