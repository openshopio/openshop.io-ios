//
//  BFJSONSerializing.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "Mantle.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFJSONSerializing` protocol extends `MTLJSONSerializing` protocol with method
 * to parse a JSON dictionary into an existing model object.
 */
@protocol BFJSONSerializing <MTLJSONSerializing>

/**
 * Parses JSON dictionary into an existing model object.
 *
 * @param JSONDictionary A dictionary representing JSON data. This should match the
 *                       format returned by NSJSONSerialization.
 * @param error An error that might occur during parsing or merging data to an existing
 *              instance of calling model class.
 * @return TRUE if an error occured, else FALSE.
 */
- (BOOL)updateWithJSONDictionary:(NSDictionary *)JSONDictionary error:( NSError * _Nullable __autoreleasing* _Nullable)error;

@end

NS_ASSUME_NONNULL_END
