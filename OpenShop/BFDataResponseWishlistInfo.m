//
//  BFDataResponseWishlistInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataResponseWishlistInfo.h"

/**
 * Properties names used to match attributes during JSON deserialization.
 */
static NSString *const BFDataResponseWishlistInfoWishlistIDPropertyName          = @"wishlistID";
static NSString *const BFDataResponseWishlistInfoIsInWishlistPropertyName        = @"isInWishlist";

/**
 * Properties JSON mappings used to match attributes during deserialization.
 */
static NSString *const BFDataResponseWishlistInfoWishlistIDPropertyJSONMapping   = @"wishlist_product_id";
static NSString *const BFDataResponseWishlistInfoIsInWishlistPropertyJSONMapping = @"is_in_wishlist";



@interface BFDataResponseWishlistInfo ()

@end


@implementation BFDataResponseWishlistInfo


#pragma mark - JSON Deserialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFDataResponseWishlistInfoWishlistIDPropertyName   : BFDataResponseWishlistInfoWishlistIDPropertyJSONMapping,
             BFDataResponseWishlistInfoIsInWishlistPropertyName : BFDataResponseWishlistInfoIsInWishlistPropertyJSONMapping,
             };
}


@end
