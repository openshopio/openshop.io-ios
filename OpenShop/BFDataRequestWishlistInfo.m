//
//  BFDataRequestWishlistInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataRequestWishlistInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFDataRequestWishlistInfoProductVariantIDPropertyName        = @"productVariantID";


/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFDataRequestWishlistInfoProductVariantIDPropertyJSONMapping = @"product_variant_id";



@interface BFDataRequestWishlistInfo ()

@end


@implementation BFDataRequestWishlistInfo


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFDataRequestWishlistInfoProductVariantIDPropertyName : BFDataRequestWishlistInfoProductVariantIDPropertyJSONMapping,
             };
}


@end
