//
//  BFWishlistButtonView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFWishlistButtonView.h"
#import "BFAppPreferences.h"
#import "UIFont+BFFont.h"
#import <POP.h>

/**
 * Wishlist button scale animation velocity.
 */
static CGFloat const wishlistButtonScaleAnimationVelocityX  = 5.0;
static CGFloat const wishlistButtonScaleAnimationVelocityY  = 5.0;
/**
 * Wishlist button scale animation starting size.
 */
static CGFloat const wishlistButtonScaleAnimationStartX     = 0.4f;
static CGFloat const wishlistButtonScaleAnimationStartY     = 0.4f;
/**
 * Wishlist button scale animation final size.
 */
static CGFloat const wishlistButtonScaleAnimationEndX       = 1.0;
static CGFloat const wishlistButtonScaleAnimationEndY       = 1.0;
/**
 * Wishlist button enlarge animation final size.
 */
static CGFloat const wishlistButtonEnlargeAnimationEndX     = 1.0;
static CGFloat const wishlistButtonEnlargeAnimationEndY     = 1.0;
/**
 * Wishlist button scale animation bounciness.
 */
static CGFloat const wishlistButtonScaleAnimationBounciness = 20.0;
/**
 * Wishlist button scale animation identification.
 */
static NSString *const wishlistButtonScaleAnimationKey      = @"wishlistButtonScaleAnimation";
/**
 * Wishlist button enlarge animation identification.
 */
static NSString *const wishlistButtonEnlargeAnimationKey    = @"wishlistButtonEnlargeAnimation";
/**
 * Wishlist button shrink animation identification.
 */
static NSString *const wishlistButtonShrinkAnimationKey     = @"wishlistButtonShrinkAnimation";


@interface BFWishlistButtonView ()

@end


@implementation BFWishlistButtonView


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}


#pragma mark - State Management

- (void)setRequestState:(BOOL)state {
    if(state) {
        [self.activityIndicator startAnimating];
    }
    else {
        [self.activityIndicator stopAnimating];
    }
    self.userInteractionEnabled = !state;
}

- (void)setSelected:(BOOL)selected {
    [self.wishlistButton setSelected:selected];
}

- (IBAction)wishlistButtonClicked:(id)sender {
    if(self.selectionBlock) {
        self.selectionBlock(self);
    }
}


#pragma mark - Wishlist Button Animations

- (void)scaleButtonWithInitialResult:(BOOL)inWishlist {
    self.isInWishlist = inWishlist;
    
    POPSpringAnimation *wishlistButtonSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    wishlistButtonSpringAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(wishlistButtonScaleAnimationVelocityX, wishlistButtonScaleAnimationVelocityY)];
    wishlistButtonSpringAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(wishlistButtonScaleAnimationStartX, wishlistButtonScaleAnimationStartY)];
    wishlistButtonSpringAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(wishlistButtonScaleAnimationEndX, wishlistButtonScaleAnimationEndY)];
    wishlistButtonSpringAnimation.springBounciness = wishlistButtonScaleAnimationBounciness;
    wishlistButtonSpringAnimation.removedOnCompletion = YES;
    wishlistButtonSpringAnimation.animationDidStartBlock = ^(POPAnimation *anim){
        self.hidden = false;
        [self setSelected:inWishlist];
    };
    
    if(![[self.wishlistButton.layer pop_animationKeys] containsObject:wishlistButtonScaleAnimationKey] &&
       ![[self.wishlistButton.layer pop_animationKeys] containsObject:wishlistButtonEnlargeAnimationKey]) {
        [self.wishlistButton.layer pop_addAnimation:wishlistButtonSpringAnimation forKey:wishlistButtonScaleAnimationKey];
    }
}

- (void)scaleButtonWithStartHandler:(void (^)(POPAnimation *anim))start didReachToValueHandler:(void (^)(POPAnimation *anim))didReachToValue {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(wishlistButtonScaleAnimationEndX, wishlistButtonScaleAnimationEndY)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(wishlistButtonScaleAnimationEndX, wishlistButtonScaleAnimationEndY)];
    scaleAnimation.springBounciness = wishlistButtonScaleAnimationBounciness;
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.animationDidReachToValueBlock = didReachToValue;
    scaleAnimation.animationDidStartBlock = start;
    
    [self.wishlistButton.layer pop_addAnimation:scaleAnimation forKey:wishlistButtonScaleAnimationKey];
}

- (void)shrinkButtonWithCompletionHandler:(void (^)(POPAnimation *anim, BOOL finished))completion {
    // shrink the original wishlist button (heart image)
    POPBasicAnimation *shrinkAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    shrinkAnimation.toValue = [NSValue valueWithCGSize:CGSizeZero];
    shrinkAnimation.completionBlock = completion;
    
    [self.wishlistButton.layer pop_addAnimation:shrinkAnimation forKey:wishlistButtonShrinkAnimationKey];
}

- (void)enlargeButtonWithStartHandler:(void (^)(POPAnimation *anim))start {
    POPBasicAnimation *enlargeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    enlargeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(wishlistButtonEnlargeAnimationEndX, wishlistButtonEnlargeAnimationEndY)];
    enlargeAnimation.removedOnCompletion = YES;
    enlargeAnimation.animationDidStartBlock = start;
    
    [self.wishlistButton.layer pop_addAnimation:enlargeAnimation forKey:wishlistButtonEnlargeAnimationKey];
}

@end
