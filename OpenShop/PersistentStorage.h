//
//  PersistentStorage.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

/**
 * `PersistentStorage` maintains persistent database storage configuration and simple access
 * to a Core Data managed object context. It manages two contexts with queue - main and a private
 * queue. Main queue context specifies that the context will be associated with the main queue,
 * private queue context specifies that the context will be associated with the private
 * dispatch queue. Both context queues are synchronized on save to prevent data loss.
 */
@interface PersistentStorage : NSObject

/**
 * Class method to access the static persistent storage instance.
 *
 * @return Singleton instance of the `PersistentStorage` class.
 */
+ (instancetype)defaultStorage;

/**
 * Returns the persistent store URL.
 *
 * @return The persistent store URL.
 */
- (NSURL *)persistentStoreURL;
/**
 * Returns the managed object model file name.
 *
 * @return The managed object model file name.
 */
- (NSString *)managedObjectModelFileName;
/**
 * Transforms managed object string identification to its core data `NSManagedObjectID`.
 *
 * @param managedObjectIDString The managed object string identification.
 * @return The `NSManagedObjectID` uniquely identifying object.
 */
+ (nullable NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString;
/**
 * Removes all managed objects saved in the persistent storage.
 */
- (void)clearDB;

NS_ASSUME_NONNULL_END

@end
