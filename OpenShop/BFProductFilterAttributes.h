//
//  BFProductFilterAttributes.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFNFiltering.h"
#import "BFProductVariantColor.h"
#import "BFProductVariantSize.h"
#import "BFProductBrand.h"
#import "BFProductPriceRange.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductFilterAttributes` serves as the products filtering attributes wrapper. It implements the `NSCopying`
 * protocol to easily create a copy of the filter attributes without mutating the original source.
 */
@interface BFProductFilterAttributes : NSObject <NSCopying>

/**
 * Selected filter items (product variant colors).
 */
@property (nonatomic, strong, nullable) NSMutableArray<BFProductVariantColor *> *selectedProductVariantColors;
/**
 * Selected filter items (product variant sizes).
 */
@property (nonatomic, strong, nullable) NSMutableArray<BFProductVariantSize *> *selectedProductVariantSizes;
/**
 * Selected filter items (product brands).
 */
@property (nonatomic, strong, nullable) NSMutableArray<BFProductBrand *> *selectedProductBrands;
/**
 * The selected product price range.
 */
@property (nonatomic, strong, nullable) BFProductPriceRange *selectedProductPriceRange;
/**
 * Filter items (product variant colors).
 */
@property (nonatomic, strong) NSMutableArray<BFProductVariantColor *> *productVariantColors;
/**
 * Filter items (product variant sizes).
 */
@property (nonatomic, strong) NSMutableArray<BFProductVariantSize *> *productVariantSizes;
/**
 * Filter items (product brands).
 */
@property (nonatomic, strong) NSMutableArray<BFProductBrand *> *productBrands;
/**
 * The product price range.
 */
@property (nonatomic, strong) BFProductPriceRange *productPriceRange;

/**
 * Updates filter items in the datasource.
 *
 * @param items The filter items.
 */
- (void)updateFilterItems:(NSArray *)items;
/**
 * Adds filter items to the datasource.
 *
 * @param items The filter items.
 */
- (void)addFilterItems:(NSArray *)items;
/**
 * Sets selected filter items of specified filter type.
 *
 * @param items The filter items.
 * @param filterType The filter items type.
 */
- (void)setSelectedFilterItems:(NSArray *)items ofFilterType:(BFNFilterType)filterType;

@end

NS_ASSUME_NONNULL_END
