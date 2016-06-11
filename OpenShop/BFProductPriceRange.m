//
//  BFProductPriceRange.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductPriceRange.h"



@implementation BFProductPriceRange


#pragma mark - BFNFiltering Protocol

- (BFNFilterType)filterType {
    return BFNProductFilterTypeRange;
}

- (id)filterValue {
    NSInteger min = self.min ? [self.min integerValue] : 0;
    NSInteger max = self.max ? [self.max integerValue] : 0;
    
    return [NSValue valueWithRange:NSMakeRange(min, labs(max-min))];
}



@end