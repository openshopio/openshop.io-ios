//
//  BFDataRequestCartDiscountInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFAPIRequestCartDiscountInfo.h"
#import "BFDataStorageAccessing.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestCartDiscountInfo` encapsulates information used in data fetching and saving
 * with shopping cart discounts requests.
 */
@interface BFDataRequestCartDiscountInfo : BFAPIRequestCartDiscountInfo <BFDataStorageAccessing>

/**
 * Minimum cart product items price to apply the discount.
 */
@property (strong, nullable) NSNumber *minCartAmount;
/**
 * Cart discount item name.
 */
@property (copy, nullable) NSString *name;
/**
 * Cart discount item type.
 */
@property (copy, nullable) NSString *type;
/**
 * Cart discount item value.
 */
@property (strong, nullable) NSNumber *value;
/**
 * Cart discount item formatted value.
 */
@property (copy, nullable) NSString *valueFormatted;
/**
 * Cart discount item quantity.
 */
@property (strong, nullable) NSNumber *quantity;


@end

NS_ASSUME_NONNULL_END

