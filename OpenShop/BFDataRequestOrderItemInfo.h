//
//  BFDataRequestOrderItemInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"
#import "BFDataStorageAccessing.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestOrderItemInfo` encapsulates information used in data fetching
 * and saving with order items models.
 */
@interface BFDataRequestOrderItemInfo : BFJSONSerializableObject <BFDataStorageAccessing>

/**
 * Order item identification.
 */
@property (strong, nullable) NSNumber *orderItemID;
/**
 * Order item quantity.
 */
@property (strong, nullable) NSNumber *quantity;
/**
 * Order item price with respect to the quantity.
 */
@property (strong, nullable) NSNumber *price;
/**
 * Order item formatted price with respect to the quantity.
 */
@property (copy, nullable) NSString *priceFormatted;
/**
 * Product variant identification.
 */
@property (strong, nullable) NSNumber *productVariantID;


@end

NS_ASSUME_NONNULL_END
