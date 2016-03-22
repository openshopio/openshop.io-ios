//
//  BFDataRequestProductInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFDataRequestPagerInfo.h"
#import "BFDataStorageAccessing.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDataRequestProductInfo` encapsulates information used when accessing remote API and in data
 * fetching with product retrieval requests. It is a subclass of `BFDataRequestPagerInfo` which adds ability
 * to specify pagination info. It contains product and its variants attributes with other attributes
 * used for filtering, product categories identification and sorting attributes. It is also conforming
 * to the `BFDataStorageAccessing` protocol to simplify data fetching requests.
 */
@interface BFDataRequestProductInfo : BFDataRequestPagerInfo <BFDataStorageAccessing>
/**
 * Product identification.
 */
@property (strong, nullable) NSNumber *productID;
/**
 * Product variant identification.
 */
@property (strong, nullable) NSNumber *productVariantID;
/**
 * Product category identification.
 */
@property (strong, nullable) NSNumber *categoryID;
/**
 * Product banner identification.
 */
@property (strong, nullable) NSNumber *bannerID;
/**
 * Product filter colors.
 */
@property (strong, nullable) NSArray *colors;
/**
 * Product filter sizes.
 */
@property (strong, nullable) NSArray *sizes;
/**
 * Product filter brands.
 */
@property (strong, nullable) NSArray *brands;
/**
 * Product filter lower price limit.
 */
@property (strong, nullable) NSNumber *priceRangeFrom;
/**
 * Product filter higher price limit.
 */
@property (strong, nullable) NSNumber *priceRangeTo;
/**
 * Product filter price range.
 */
@property (strong, nullable) NSValue *priceRange;
/**
 * Product filtering search query text.
 */
@property (copy, nullable) NSString *searchQuery;
/**
 * Product sorting type.
 */
@property (strong, nullable) NSNumber *sortType;
/**
 * Product menu category identification.
 */
@property (strong, nullable) NSNumber *menuCategory;
/**
 * Product static menu category identification.
 */
@property (strong, nullable) NSNumber *staticMenuCategory;
/**
 * Includes specified value (`related` includes related products).
 */
@property (copy, nullable) NSString *include;
/**
 * Product results title.
 */
@property (copy, nullable) NSString *resultsTitle;

/**
 * Initializes a `BFDataRequestProductInfo` object with product identification.
 *
 * @param productID The product identification.
 * @return The newly-initialized `BFDataRequestProductInfo`.
 */
- (instancetype)initWithProductIdentification:(NSNumber *)productID;
/**
 * Initializes a `BFDataRequestProductInfo` object with product category identification.
 *
 * @param categoryID The product category identification.
 * @return The newly-initialized `BFDataRequestProductInfo`.
 */
- (instancetype)initWithCategory:(NSNumber *)categoryID;
/**
 * Initializes a `BFDataRequestProductInfo` object with product category identification.
 *
 * @param categoryID The product category identification.
 * @param offset The record offset.
 * @param limit The maximum number of records.
 * @return The newly-initialized `BFDataRequestProductInfo`.
 */
- (instancetype)initWithCategory:(NSNumber *)categoryID
                          offset:(NSNumber *)offset
                           limit:(NSNumber *)limit;

@end

NS_ASSUME_NONNULL_END
