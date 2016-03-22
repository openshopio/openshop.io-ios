//
//  BFRecord.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import Foundation;
@import CoreData;

#import <MMRecord/MMRecord.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFRecord` extends `MMRecord` which provides a pattern for interfacing with a server to retrieve records.
 * It represents Core Data managed object base class and all Core Data managed objects should inherit from this
 * class to respect the default settings.
 */
@interface BFRecord : MMRecord

/**
 * `MagicalRecord` entities fetching support, translates entity class name to its managed object model name.
 *
 * @return The entity managed object model name.
 */
+ (NSString *)entityName;
/**
 * The `MagicalRecord` options applied when fetching collections of entities.
 *
 * @return The `MagicalRecord` collection of entities fetching options.
 */
+ (MMRecordOptions *)collectionOptions;

@end

NS_ASSUME_NONNULL_END

