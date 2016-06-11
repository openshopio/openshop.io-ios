//
//  BFProductVariantSize+BFNFiltering.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductVariantSize+BFNFiltering.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFProductVariantSizeSizeIDPropertyName = @"sizeID";
static NSString *const BFProductVariantSizeValuePropertyName  = @"value";


/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFProductVariantSizeSizeIDPropertyJSONMapping = @"id";
static NSString *const BFProductVariantSizeValuePropertyJSONMapping  = @"value";


@implementation BFProductVariantSize (BFNFiltering)


#pragma mark - BFNFiltering Protocol

- (BFNFilterType)filterType {
    return BFNProductFilterTypeSelect;
}

- (id)filterValue {
    return self.value ? (NSString *)self.value : @"";
}


#pragma mark - BFAPIResponseDataModelMapping (JSON Serialization)

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFProductVariantSizeSizeIDPropertyName : BFProductVariantSizeSizeIDPropertyJSONMapping,
             BFProductVariantSizeValuePropertyName  : BFProductVariantSizeValuePropertyJSONMapping,
             };
}

@end