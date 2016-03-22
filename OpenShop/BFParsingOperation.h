//
//  BFParsingOperation.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFParsingOperation` is the base parsing operation to encapsulate the data
 * and required properties in a single task. It contains basic properties and
 * initialization methods used by all descendants.
 */
@interface BFParsingOperation : NSOperation

/**
 * The raw data to be parsed.
 */
@property (nonatomic, strong) id rawData;
/**
 * The managed object context of the resulting data model objects.
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
/**
 * The completion block to notify with the parsed results.
 */
@property (nonatomic, copy) BFAPIDataLoadingCompletionBlock completion;
/**
 * The array of already parsed data model objects.
 */
@property (nonatomic, strong) NSArray *records;

/**
 * Initializes a `BFParsingOperation` object with the data to be parsed and completion block.
 *
 * @param rawData The data to be parsed.
 * @param completion The completion block to call when the operation completes.
 * @return The newly-initialized `BFParsingOperation`.
 */
- (instancetype)initWithRawData:(id)rawData completionBlock:(nullable BFAPIDataLoadingCompletionBlock)completion;
/**
 * Initializes a `BFParsingOperation` object with the data to be parsed, completion block and an array of existing data models.
 *
 * @param rawData The data to be parsed.
 * @param completion The completion block to call when the operation completes.
 * @param records The array of existing data models.
 * @return The newly-initialized `BFParsingOperation`.
 */
- (instancetype)initWithRawData:(id)rawData completionBlock:(nullable BFAPIDataLoadingCompletionBlock)completion records:(nullable NSArray *)records;
/**
 * Initializes a `BFParsingOperation` object the data to be parsed, managed object context of the data models, completion block and an array of existing data models.
 *
 * @param rawData The data to be parsed.
 * @param managedObjectContext The managed object context.
 * @param completion The completion block to call when the operation completes.
 * @param records The array of existing data models.
 * @return The newly-initialized `BFParsingOperation`.
 */
- (instancetype)initWithRawData:(id)rawData managedObjectContext:(NSManagedObjectContext *)managedObjectContext completionBlock:(nullable BFAPIDataLoadingCompletionBlock)completion records:(nullable NSArray *)records;


@end

NS_ASSUME_NONNULL_END
