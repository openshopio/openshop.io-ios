//
//  BFProductsCollectionViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseCollectionViewCellExtension.h"
#import "BFProduct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductsCollectionViewCellExtension` manages products displaying in a collection view.
 */
@interface BFProductsCollectionViewCellExtension : BFBaseCollectionViewCellExtension

/**
 * Products data source.
 */
@property (nonatomic, strong) NSArray<BFProduct *> *products;
/**
 * Flag indicating the loading footer view visibility.
 */
@property (nonatomic, assign) BOOL showsFooter;

/**
 * Resets the products calculated height cache.
 */
- (void)resetCache;

@end

NS_ASSUME_NONNULL_END


