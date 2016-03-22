//
//  BFWishlistItemsCollectionViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseCollectionViewCellExtension.h"
#import "BFWishlistItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFWishlistItemsCollectionViewCellExtension` manages wishlist items displaying in a collection view.
 */
@interface BFWishlistItemsCollectionViewCellExtension : BFBaseCollectionViewCellExtension

/**
 * Wishlist items data source.
 */
@property (nonatomic, strong) NSArray<BFWishlistItem *> *wishlistItems;
/**
 * Flag indicating the loading footer view visibility.
 */
@property (nonatomic, assign) BOOL showsFooter;


@end

NS_ASSUME_NONNULL_END


