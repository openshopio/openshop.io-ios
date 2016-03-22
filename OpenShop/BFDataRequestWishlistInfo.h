//
//  BFDataRequestWishlistInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFDataRequestPagerInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestWishlistInfo` encapsulates information used when accessing remote API and in data
 * fetching with wishlist retrieval requests. Wishlist requests are identified with wishlist
 * item identification or the corresponding product variant identification.
 */
@interface BFDataRequestWishlistInfo : BFDataRequestPagerInfo
/**
 * Wishlist item identification.
 */
@property (strong, nullable) NSNumber *wishlistID;
/**
 * Product variant identification.
 */
@property (strong, nullable) NSNumber *productVariantID;

@end

NS_ASSUME_NONNULL_END
