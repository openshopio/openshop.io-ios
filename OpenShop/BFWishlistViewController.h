//
//  BFWishlistViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


@import UIKit;
#import "BFCollectionViewController.h"
#import "BFProductZoomAnimatorDelegate.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFWishlistViewController` displays products in wishlist.
 */
@interface BFWishlistViewController :  BFCollectionViewController <BFCustomAppearance, BFProductZoomAnimatorDelegate>



@end

NS_ASSUME_NONNULL_END
