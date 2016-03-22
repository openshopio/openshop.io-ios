//
//  BFJSONResponseSerializer.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFJSONResponseSerializer` is a subclass of `AFJSONResponseSerializer` that adds
 * response status code examination. When the response contains client error status
 * code user is logged out.
 */
@interface BFJSONResponseSerializer : AFJSONResponseSerializer


@end

NS_ASSUME_NONNULL_END
