//
//  TSEventModel.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSEventModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL selected;

@end
