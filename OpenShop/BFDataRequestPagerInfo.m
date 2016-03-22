//
//  BFDataRequestPagerInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataRequestPagerInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFDataRequestPagerInfoOffsetPropertyName        = @"offset";
static NSString *const BFDataRequestPagerInfoLimitPropertyName         = @"limit";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFDataRequestPagerInfoOffsetPropertyJSONMapping = @"offset";
static NSString *const BFDataRequestPagerInfoLimitPropertyJSONMapping  = @"limit";


@interface BFDataRequestPagerInfo ()

@end


@implementation BFDataRequestPagerInfo


#pragma mark - Initialization

- (instancetype)initWithOffset:(NSNumber *)offset
                         limit:(NSNumber *)limit {
    self = [super init];
    if (self) {
        _offset = offset;
        _limit = limit;
    }
    return self;
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFDataRequestPagerInfoOffsetPropertyName : BFDataRequestPagerInfoOffsetPropertyJSONMapping,
             BFDataRequestPagerInfoLimitPropertyName  : BFDataRequestPagerInfoLimitPropertyJSONMapping
             };
}




@end
