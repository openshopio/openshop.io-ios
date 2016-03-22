//
//  BFProductVariantColor+BFNFiltering.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductVariantColor+BFNFiltering.h"


/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFProductVariantColorColorIDPropertyName  = @"colorID";
static NSString *const BFProductVariantColorHexValuePropertyName = @"hexValue";
static NSString *const BFProductVariantColorImageURLPropertyName = @"imageURL";
static NSString *const BFProductVariantColorNamePropertyName     = @"name";


/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFProductVariantColorColorIDPropertyJSONMapping  = @"id";
static NSString *const BFProductVariantColorHexValuePropertyJSONMapping = @"code";
static NSString *const BFProductVariantColorImageURLPropertyJSONMapping = @"img";
static NSString *const BFProductVariantColorNamePropertyJSONMapping     = @"value";



@implementation BFProductVariantColor (BFNFiltering)


#pragma mark - BFNFiltering Protocol

- (BFNFilterType)filterType {
    return BFNProductFilterTypeColor;
}

- (id)filterValue {
    return self.name ? (NSString *)self.name : @"";
}


#pragma mark - BFAPIResponseDataModelMapping (JSON Serialization)

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFProductVariantColorColorIDPropertyName  : BFProductVariantColorColorIDPropertyJSONMapping,
             BFProductVariantColorHexValuePropertyName : BFProductVariantColorHexValuePropertyJSONMapping,
             BFProductVariantColorImageURLPropertyName : BFProductVariantColorImageURLPropertyJSONMapping,
             BFProductVariantColorNamePropertyName     : BFProductVariantColorNamePropertyJSONMapping,
             };
}


@end