//
// TSWebController.h
//  PetFriend
//
//  Created by liuhao on 2018/12/9.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSViewController.h"

@interface TSWebController : TSViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, copy) void(^didLoadCompleteBlock)(TSWebController *vc);

- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithHtmlString:(NSString *)htmlString;

@end
