//
//  BFNSelection.h
//  ZOOT
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNSelection` protocol specifies methods required during the selection process
 * in the `BFNSelectionViewController`.
 */
@protocol BFNSelection <NSObject>

/**
 * Returns a search predicate used to match items during the items filtering with
 * the text search query.
 *
 * @param query The text search query.
 * @return The search predicate.
 */
+(NSPredicate *)predicateWithSearchQuery:(nullable NSString *)query;
/**
 * Returns an alphabetical section index title of item.
 *
 * @return The alphabetical section index title.
 */
-(NSString *)sectionIndexTitle;
/**
 * Compares the item with an item implementing the same protocol.
 *
 * @param item The item implementing the same protocol.
 * @return The value indicating the lexical ordering.
 */
-(NSComparisonResult)compare:(id<BFNSelection>)item;
/**
 * Returns the item name displayed in a selection list.
 *
 * @return The item display name.
 */
-(NSString *)displayName;

@optional
/**
 * Returns the item image URL displayed in a selection list.
 *
 * @return The item display image URL.
 */
-(NSURL *)displayImageURL;

@end

NS_ASSUME_NONNULL_END
