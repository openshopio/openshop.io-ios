//
//  BFProductDetailHeaderView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductDetailHeaderView.h"
#import "BFAppPreferences.h"
#import "UIFont+BFFont.h"
#import <IDMPhotoBrowser.h>
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIImage+BFImageResize.h"
#import <UIImageView+AFNetworking.h>
#import <POP.h>
#import "BFProductImageView.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"


/**
 * The page control scale animation velocity.
 */
static CGFloat const pageControlScaleAnimationVelocityX  = 5.0;
static CGFloat const pageControlScaleAnimationVelocityY  = 5.0;
/**
 * The page control scale animation starting size.
 */
static CGFloat const pageControlScaleAnimationStartX     = 0.4;
static CGFloat const pageControlScaleAnimationStartY     = 0.4;
/**
 * The page control scale animation final size.
 */
static CGFloat const pageControlScaleAnimationEndX       = 1.0;
static CGFloat const pageControlScaleAnimationEndY       = 1.0;
/**
 * The page control scale animation bounciness.
 */
static CGFloat const pageControlScaleAnimationBounciness = 20.0;
/**
 * The page control scale animation identification.
 */
static NSString *const pageControlScaleAnimationKey      = @"pageControlScaleSpringAnimation";
/**
 * The swipe view images scroll animation duration.
 */
static CGFloat const swipeViewScrollAnimationDuration    = 1.0;



@interface BFProductDetailHeaderView ()

@end


@implementation BFProductDetailHeaderView


#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setupContentWithDelegate:(id<BFProductDetailHeaderViewDelegate>)delegate {
    self.delegate = delegate;
    self.imageSwipeView.delegate = self;
    self.imageSwipeView.dataSource = self;
    self.wishlistButtonView.hidden = true;
    
    // forward wishlist button selection
    __weak __typeof__(self) weakSelf = self;
    self.wishlistButtonView.selectionBlock = ^(BFWishlistButtonView *wishlistButtonView) {
        if(weakSelf.delegate) {
            [weakSelf.delegate wishlistButtonClicked:wishlistButtonView];
        }
    };
}


#pragma mark - Content update

- (void)updateContent {
    // labels
    self.nameLabel.text = self.product ? self.product.name : nil;
    [self.priceLabel setAttributedText:self.product ? [self.product priceAndDiscountFormattedWithPercentage:YES] : nil];

    // page control
    self.pageControl.userInteractionEnabled = self.finishedLoading;
    self.pageControl.numberOfPages = self.images.count;
    
    // swipe view
    self.imageSwipeView.wrapEnabled = (self.images.count > 1);
    self.imageSwipeView.currentItemIndex = 0;
    [self.imageSwipeView reloadData];
}


#pragma mark - WishlistButtonView

- (void)updateWishlist:(BOOL)inWishlist hidden:(BOOL)hidden {
    if(!hidden) {
        [self.wishlistButtonView scaleButtonWithInitialResult:inWishlist];
    }
    else {
        [self.wishlistButtonView setHidden:hidden];
    }
}


#pragma mark - Page Control

- (void)animatePageControl {
    if(self.images.count > 1) {
        // scale animation
        POPSpringAnimation *pageControlSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        // scale properties
        pageControlSpringAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(pageControlScaleAnimationVelocityX, pageControlScaleAnimationVelocityY)];
        pageControlSpringAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(pageControlScaleAnimationStartX, pageControlScaleAnimationStartY)];
        pageControlSpringAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(pageControlScaleAnimationEndX, pageControlScaleAnimationEndY)];
        pageControlSpringAnimation.springBounciness = pageControlScaleAnimationBounciness;
        pageControlSpringAnimation.removedOnCompletion = YES;
        // update number of page control pages at start
        pageControlSpringAnimation.animationDidStartBlock = ^(POPAnimation *anim) {
            self.pageControl.numberOfPages = self.images.count;
        };
        [self.pageControl.layer pop_addAnimation:pageControlSpringAnimation forKey:pageControlScaleAnimationKey];
    }
}


#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.images.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    BFProductImageView *imageView = [view isKindOfClass:[BFProductImageView class]] ? (BFProductImageView *)view : [[BFProductImageView alloc] initWithFrame:swipeView.bounds];
    
    if (index < self.images.count) {
        [imageView setImageWithURL:[self.images objectAtIndex:index] placeholderImage:imageView.placeholderImage];
        return imageView;
    }
    
    return [[UIView alloc] init];
}


#pragma mark - SwipeViewDelegate

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentItemIndex;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:self.images animatedFromView:self.imageSwipeView];
    BFProductImageView *imageView = (BFProductImageView *)[self.imageSwipeView itemViewAtIndex:index];


    // image browser controller
    browser.scaleImage = imageView.image;
    browser.displayCounterLabel = YES;
    browser.forceHideStatusBar = YES;
    browser.useWhiteBackgroundColor = YES;
    [browser setInitialPageIndex:index];
    browser.view.tintColor = [UIColor BFN_pinkColor];

    if(self.delegate) {
        [self.delegate presentViewController:browser animated:YES];
    }
}


#pragma mark - Page Control

- (IBAction)pageControlClicked:(UIPageControl *)pageControl {
    [self.imageSwipeView scrollToItemAtIndex:pageControl.currentPage duration:swipeViewScrollAnimationDuration];
}


@end
