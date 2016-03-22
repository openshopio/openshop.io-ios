//
//  BFDataRequestOrderInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFAPIRequestOrderInfo.h"
#import "BFDataStorageAccessing.h"
#import "BFDataRequestOrderItemInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestOrderInfo` encapsulates information used in data fetching
 * and saving with order requests.
 */
@interface BFDataRequestOrderInfo : BFAPIRequestOrderInfo <BFDataStorageAccessing>

/**
 * Order remote identification.
 */
@property (strong, nullable) NSNumber *remoteID;
/**
 * Order status.
 */
@property (copy, nullable) NSString *status;
/**
 * Order total price.
 */
@property (strong, nullable) NSNumber *totalPrice;
/**
 * Order formatted total price.
 */
@property (copy, nullable) NSString *totalPriceFormatted;
/**
 * Order items information.
 */
@property (strong, nullable) NSArray<BFDataRequestOrderItemInfo *> *orderItems;


@end

NS_ASSUME_NONNULL_END
