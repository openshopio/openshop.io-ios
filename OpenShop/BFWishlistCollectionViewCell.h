//
//  BFWishlistCollectionViewCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCollectionViewCell.h"
#import "BFWishlistButtonView.h"

/**
 * `BFWishlistCollectionViewCell` extends the base collection view cell wrapper with the wishlist button
 * view. The wishlist button view manages all events itself.
 */
@interface BFWishlistCollectionViewCell : BFCollectionViewCell

/**
 * The wishlist button view.
 */
@property (nonatomic, weak) IBOutlet BFWishlistButtonView *wishlistButtonView;


@end
