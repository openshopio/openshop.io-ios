//
//  BFDataRequestCartProductInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFAPIRequestCartProductInfo.h"
#import "BFDataStorageAccessing.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestCartProductInfo` encapsulates information used in data fetching and saving
 * with shopping cart products requests.
 */
@interface BFDataRequestCartProductInfo : BFAPIRequestCartProductInfo <BFDataStorageAccessing>
/**
 * Cart product remote identification.
 */
@property (strong, nullable) NSNumber *cartRemoteID;
/**
 * Cart product total price with respect to the quantity.
 */
@property (strong, nullable) NSNumber *totalPrice;
/**
 * Cart product formatted total price with respect to the quantity.
 */
@property (copy, nullable) NSString *totalPriceFormatted;
/**
 * Cart product reservation flag.
 */
@property (strong, nullable) NSNumber *isReservation;
/**
 * Cart product reservation expiration time.
 */
@property (strong, nullable) NSDate *expiration;


@end

NS_ASSUME_NONNULL_END

