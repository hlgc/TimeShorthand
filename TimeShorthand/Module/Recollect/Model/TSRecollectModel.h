//
//  TSRecollectModel.h
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSRecollectModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray <NSString *>*images;
@property (nonatomic, copy) NSString *time;

@end

