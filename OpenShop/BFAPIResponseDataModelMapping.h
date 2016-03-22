//
//  BFAPIResponseDataModelMapping.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAPIResponseDataModelMapping` protocol specifies how to map data model properties
 * to the different key paths in JSON.
 */
@protocol BFAPIResponseDataModelMapping

/**
 * Data model properties mapping to the JSON key paths.
 *
 * @return The data model properties mapping.
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey;


@end

NS_ASSUME_NONNULL_END
