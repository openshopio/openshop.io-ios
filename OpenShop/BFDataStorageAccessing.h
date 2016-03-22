//
//  BFDataStorageAccessing.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataStorageAccessing` protocol specifies methods used for data model fetching and saving
 * to the local database. It should simplify the process of data model information object
 * translation to the data query predicate or fetch request formatting and data model attributes
 * updating.
 */
@protocol BFDataStorageAccessing <NSObject>

@optional

/**
 * Formats data fetch predicate from model information object.
 *
 * @return Formatted predicate to fetch data models.
 */
- (NSPredicate *)dataFetchPredicate;

/**
 * Updates managed data model attributes.
 *
 * @param model The data model object.
 * @param context The data model managed object context.
 */
- (void)updateDataModel:(NSManagedObject *_Nonnull __autoreleasing *_Nonnull)model inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
