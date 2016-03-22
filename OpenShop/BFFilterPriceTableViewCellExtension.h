//
//  BFFilterPriceTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFProductPriceRange.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFFilterPriceTableViewCellExtension` displays product filtering option with a price range.
 */
@interface BFFilterPriceTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * The product price range.
 */
@property (nonatomic, strong) BFProductPriceRange *productPriceRange;
/**
 * The currently selected product price range.
 */
@property (nonatomic, strong, nullable) BFProductPriceRange *selectedPriceRange;
/**
 * The price currency.
 */
@property (nonatomic, copy) NSString *currency;
/**
 * The price range selection block callback.
 */
@property (nonatomic, copy) void (^priceRangeChanged)(BFProductPriceRange *productPriceRange);

@end



NS_ASSUME_NONNULL_END


