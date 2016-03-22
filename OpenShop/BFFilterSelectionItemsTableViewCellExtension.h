//
//  BFFilterSelectionItemsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFProductPriceRange.h"
#import "BFProductBrand.h"
#import "BFProductFilterAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFFilterSelectionItemsTableViewCellExtension` displays product filtering options
 * that use the list selection interface.
 */
@interface BFFilterSelectionItemsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Product filter attributes and their selected values.
 */
@property (nonatomic, strong) BFProductFilterAttributes *filterAttributes;

@end



NS_ASSUME_NONNULL_END


