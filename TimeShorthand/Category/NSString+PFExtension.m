//
//  NSString+PFExtension.m
//  PetFriend
//
//  Created by liuhao on 2018/12/8.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "NSString+PFExtension.h"

@implementation NSString (PFExtension)

+ (NSString *)transformedValue:(NSUInteger)value {
    
    double convertedValue = value;
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"MB",@"GB",@"TB", @"PB", @"EB", @"ZB", @"YB"];
    NSUInteger base = 1024 * 1024 * 1024;
    while (convertedValue > base) {
        convertedValue /= base;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}


@end
