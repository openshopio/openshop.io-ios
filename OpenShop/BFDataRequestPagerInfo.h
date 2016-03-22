//
//  BFDataRequestPagerInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestPagerInfo` encapsulates information used in data fetching requests which support pagination.
 * It contains record minimum offset in the data source and limit specifying number of records in a response.
 */
@interface BFDataRequestPagerInfo : BFJSONSerializableObject
/**
 * Record offset.
 */
@property (strong, nullable) NSNumber *offset;
/**
 * Limit specifying number of records.
 */
@property (strong, nullable) NSNumber *limit;


/**
 * Initializes a `BFDataRequestPagerInfo` object with offset and limit.
 *
 * @param offset The record offset.
 * @param limit The maximum number of records.
 * @return The newly-initialized `BFDataRequestPagerInfo`.
 */
- (instancetype)initWithOffset:(NSNumber *)offset
                         limit:(NSNumber *)limit;


@end

NS_ASSUME_NONNULL_END
