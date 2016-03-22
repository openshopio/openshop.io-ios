//
//  BFDataResponseWishlistInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataResponseWishlistInfo` encapsulates information retrieved from API response on the
 * wishlist fetching requests. Wishlist response contains the wishlist item identification
 * and a confirmation of the product variatnt existence in the wishlist.
 */
@interface BFDataResponseWishlistInfo : BFJSONSerializableObject
/**
 * Wishlist item identification.
 */
@property (strong, nullable) NSNumber *wishlistID;
/**
 * Product variant existence in the wishlist.
 */
@property (strong, nullable) NSNumber *isInWishlist;

@end

NS_ASSUME_NONNULL_END
