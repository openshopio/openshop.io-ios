//
//  BFAPIRequestCartDiscountInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFAPIRequestCartDiscountInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFAPIRequestCartDiscountInfoDiscountCodePropertyName           = @"discountCode";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFAPIRequestCartDiscountInfoDiscountCodePropertyJSONMapping    = @"code";


@implementation BFAPIRequestCartDiscountInfo

#pragma mark - Initialization

- (instancetype)initWithDiscountCode:(NSString *)discountCode {
    self = [super init];
    if (self) {
        _discountCode = discountCode;
    }
    return self;
}

- (instancetype)initWithDiscountIdentifier:(NSNumber *)discountID {
    self = [super init];
    if (self) {
        _discountID = discountID;
    }
    return self;
}

#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFAPIRequestCartDiscountInfoDiscountCodePropertyName : BFAPIRequestCartDiscountInfoDiscountCodePropertyJSONMapping,
             };
}


@end
