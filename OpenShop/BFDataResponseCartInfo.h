//
//  BFDataResponseCartInfo.h
//  OpenShop
//
//  Created by Petr Škorňok on 02.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataResponseCartInfo` encapsulates information retrieved from API response on the
 * cart/info fetching requests. CartInfo response contains number of products
 * in the cart, total price and total price formatted.
 */
@interface BFDataResponseCartInfo : BFJSONSerializableObject
/**
 * Count of products in the cart.
 */
@property (strong, nullable) NSNumber *productCount;
/**
 * Total price.
 */
@property (strong, nullable) NSNumber *totalPrice;
/**
 * Total price formatted.
 */
@property (strong, nullable) NSString *totalPriceFormatted;

@end

NS_ASSUME_NONNULL_END
