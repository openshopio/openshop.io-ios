//
//  BFWishlistButtonView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFButton.h"
#import <POP.h>

NS_ASSUME_NONNULL_BEGIN

@class BFWishlistButtonView;

/**
 * The wishlist button selection block type.
 */
typedef void (^BFWishlistButtonSelectionBlock)(BFWishlistButtonView *buttonView);

/**
 * `BFWishlistButtonView` encapsulates the wishlist button and activity indicator. It also manages
 * the wishlist button selections and its animation.
 */
IB_DESIGNABLE
@interface BFWishlistButtonView : UIView

/**
 * The wishlist button.
 */
@property (nonatomic, weak) IBOutlet BFButton *wishlistButton;
/**
 * The activity indicator.
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
/**
 * The wishlist button selection block.
 */
@property (nonatomic, copy) BFWishlistButtonSelectionBlock selectionBlock;
/**
 * Flag indicating the wishlist button selection state.
 */
@property (nonatomic, assign) BOOL isInWishlist;


/**
 * Sets the wishlist button selection state.
 *
 * @param selected The wishlist button selection state.
 */
- (void)setSelected:(BOOL)selected;
/**
 * Sets the wishlist button view state. The state consists of some activity in progress or
 * the wishlist button visibility.
 *
 * @param animating The wishlist button view stat (TRUE if activity is in progress).
 */
- (void)setRequestState:(BOOL)animating;


/**
 * Scales the wishlist button with animation based on the state.
 *
 * @param inWishlist If TRUE the wishlist button gets selected when the animation completes.
 */
- (void)scaleButtonWithInitialResult:(BOOL)inWishlist;
/**
 * Enlarges the wishlist button with start handler.
 *
 * @param start The animation start handler.
 */
- (void)enlargeButtonWithStartHandler:(void (^)(POPAnimation *anim))start;
/**
 * Shrinks the wishlist button with completion handler.
 *
 * @param completion The animation completion handler.
 */
- (void)shrinkButtonWithCompletionHandler:(void (^)(POPAnimation *anim, BOOL finished))completion;
/**
 * Scales the wishlist button with start handler and handler notified when the maximum scale value is reached.
 *
 * @param start The animation start handler.
 * @param didReachToValue The handler notified when the max scale value is reached.
 */
- (void)scaleButtonWithStartHandler:(void (^)(POPAnimation *anim))start didReachToValueHandler:(void (^)(POPAnimation *anim))didReachToValue;


@end



NS_ASSUME_NONNULL_END
