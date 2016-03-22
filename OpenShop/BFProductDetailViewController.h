//
//  BFProductDetailViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewController.h"
#import "BFProductDetailHeaderView.h"
#import "BFWishlistItem.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFProductDetailViewController` displays the product information details.
 */
@interface BFProductDetailViewController : BFTableViewController <BFCustomAppearance, BFProductDetailHeaderViewDelegate>

/**
 * The product data model.
 */
@property (nonatomic, strong, nullable) BFProduct *product;
/**
 * The wishlist item data model.
 */
@property (nonatomic, strong, nullable) BFWishlistItem *wishlistItem;
/**
 * The product info.
 */
@property (nonatomic, strong) BFDataRequestProductInfo *productInfo;
/**
 * The product detail header view.
 */
@property (nonatomic, strong) BFProductDetailHeaderView *headerView;


@end

NS_ASSUME_NONNULL_END


