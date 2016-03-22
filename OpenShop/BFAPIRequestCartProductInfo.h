//
//  BFAPIRequestCartProductInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFDataRequestPagerInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAPIRequestCartProductInfo` encapsulates information used when accessing remote API with
 * shopping cart requests. It is a subclass of `BFDataRequestPagerInfo` which adds ability
 * to specify pagination info.
 */
@interface BFAPIRequestCartProductInfo : BFDataRequestPagerInfo
/**
 * Product variant identification.
 */
@property (strong, nullable) NSNumber *productVariantID;
/**
 * Product variant quantity.
 */
@property (strong, nullable) NSNumber *quantity;
/**
 * Cart product identification.
 */
@property (strong, nullable) NSNumber *cartProductID;

/**
 * Initializes a `BFAPIRequestCartProductInfo` object with product variant identification and its quantity.
 *
 * @param productVariantIdentification The product variant identification.
 * @param quantity The product variant quantity.
 * @return The newly-initialized `BFAPIRequestCartProductInfo`.
 */
- (instancetype)initWithProductVariantIdentification:(NSNumber *)productVariantIdentification
                                            quantity:(NSNumber *)quantity;
/**
 * Initializes a `BFAPIRequestCartProductInfo` object with cart product identification and its quantity.
 *
 * @param cartProductIdentification The cart product identification.
 * @param quantity The product variant quantity.
 * @return The newly-initialized `BFAPIRequestCartProductInfo`.
 */
- (instancetype)initWithCartProductIdentification:(NSNumber *)cartProductIdentification
                                         quantity:(NSNumber *)quantity;
/**
 * Initializes a `BFAPIRequestCartProductInfo` object with product variant identification, cart product identification and its quantity.
 *
 * @param productVariantIdentification The product variant identification.
 * @param cartProductIdentification The cart product identification.
 * @param quantity The product variant quantity.
 * @return The newly-initialized `BFAPIRequestCartProductInfo`.
 */
- (instancetype)initWithProductVariantIdentification:(NSNumber *)productVariantIdentification
                           cartProductIdentification:(NSNumber *)cartProductIdentification
                                            quantity:(NSNumber *)quantity;



@end

NS_ASSUME_NONNULL_END

