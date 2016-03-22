//
//  BFJSONSerializableObject.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFJSONSerializing.h"
#import <Mantle/MTLModel.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFJSONSerializableObject` implements `BFJSONSerializing` protocol allowing object
 * to be parsed from and serialized to JSON. It is considered as the default implementation
 * where the JSON keys match the serialized object property names.
 */
@interface BFJSONSerializableObject : MTLModel <BFJSONSerializing>

/**
 * Converts a model object into a JSON dictionary representation.
 *
 * @param error The error that might occur during the serialization.
 * @return The JSON dictionary, or nil if a serialization error occurred.
 */
- (NSDictionary *)JSONDictionaryWithError:(NSError *__autoreleasing*)error;

/**
 * Creates new `BFJSONSerializableObject` initialized with data from a JSON dictionary.
 *
 * @param dictionaryValue The data JSON dictionary.
 * @param error The error that might occur during the deserialization.
 * @return The newly-initialized `BFJSONSerializableObject`.
 */
+ (instancetype)deserializedModelFromDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error;


@end

NS_ASSUME_NONNULL_END
