//
//  BFProductZoomAnimatorDelegate.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProduct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductZoomAnimatorDelegate` protocol specifies methods required by the product zoom animator.
 */
@protocol BFProductZoomAnimatorDelegate

/**
 * Returns the collection view cell corresponding with the animated item.
 *
 * @param item The animated item.
 * @return The collection view cell.
 */
- (nullable UICollectionViewCell *)collectionViewCellForItem:(id)item;


@end

NS_ASSUME_NONNULL_END
