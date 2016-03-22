//
//  BFParsedResult.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"
#import "BFAPIResponseDataModelMapping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFParsedResult` simulates serializable data model object. It is designed as a wrapper
 * of the managed object context model preserving all the serializable object requirements.
 * Each parsed result has to be setup with data model class before any use. Data model class
 * has to implement the `BFAPIResponseDataModelMapping` protocol.
 */
@interface BFParsedResult : BFJSONSerializableObject


/**
 * Returns data model object filled with parsed data from the JSON dictionary.
 *
 * @param dictionary The JSON dictionary.
 * @return The data model object.
 */
+ (id)dataModelFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
