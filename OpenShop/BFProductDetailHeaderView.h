//
//  BFProductDetailHeaderView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFAppAppearance.h"
#import "BFButton.h"
#import "BFWishlistButtonView.h"
#import "SwipeView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductDetailHeaderViewDelegate` notifies the table view delegate of the changes
 * and requests a view controller presentation.
 */
@protocol BFProductDetailHeaderViewDelegate

/**
 * Requests a view controller presentation with animation.
 *
 * @param viewController The view controller to be presented.
 * @param animated The view controller is presented with animation if set.
 */
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 * Wishlist button selection has changed.
 *
 * @param wishlistButtonView The wishlist button view.
 */
- (void)wishlistButtonClicked:(BFWishlistButtonView *)wishlistButtonView;

@end


/**
 * `BFProductDetailHeaderView` represents the product details table view header. It displays
 * basic product info, its variants images and the wishlist action button.
 */
IB_DESIGNABLE
@interface BFProductDetailHeaderView : UIView <SwipeViewDataSource, SwipeViewDelegate>

/**
 * The images swipe view page control.
 */
@property (nonatomic, assign) IBOutlet UIPageControl *pageControl;
/**
 * The images horizontal swipe view.
 */
@property (nonatomic, assign) IBOutlet SwipeView *imageSwipeView;
/**
 * The wishlist button view.
 */
@property (nonatomic, assign) IBOutlet BFWishlistButtonView *wishlistButtonView;
/**
 * Product name text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/**
 * Product price text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/**
 * Product variants images.
 */
@property (nonatomic, strong) NSArray<NSURL *> *images;
/**
 * Product data model.
 */
@property (nonatomic, strong, nullable) BFProduct *product;
/**
 * Flag indicating whether the product details are being fetched.
 */
@property (nonatomic, assign) BOOL finishedLoading;
/**
 * Product header view delegate.
 */
@property (nonatomic, assign) id<BFProductDetailHeaderViewDelegate> delegate;

/**
 * Initializes content with the delegate.
 *
 * @param delegate The product header view delegate.
 */
- (void)setupContentWithDelegate:(id<BFProductDetailHeaderViewDelegate>)delegate;

/**
 * Updates the header view content.
 */
- (void)updateContent;
/**
 * Updates the wishlist view state.
 */
- (void)updateWishlist:(BOOL)inWishlist hidden:(BOOL)hidden;
/**
 * Animates the images swipe view page control.
 */
- (void)animatePageControl;

@end



NS_ASSUME_NONNULL_END
