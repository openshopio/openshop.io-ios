//
//  BFViewControllerProductZoomOutAnimator.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewControllerProductZoomOutAnimator.h"
#import "BFCollectionViewController.h"
#import "BFCollectionViewCell.h"
#import "BFProductDetailViewController.h"
#import "BFProductZoomAnimatorDelegate.h"
#import "BFWishlistViewController.h"

@interface BFViewControllerProductZoomOutAnimator ()


@end


@implementation BFViewControllerProductZoomOutAnimator


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // replacing view controller
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // replaced view controller
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if(![fromViewController isKindOfClass:[BFProductDetailViewController class]] || !((BFProductDetailViewController *)fromViewController).product) {
        [transitionContext completeTransition:YES];
        return;
    }

    BFProductDetailHeaderView *productHeaderView = ((BFProductDetailViewController *)fromViewController).headerView;
    
    // product image snapshot
    UIView *imageSnapshot = [productHeaderView.imageSwipeView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:productHeaderView.imageSwipeView.frame fromView:productHeaderView.imageSwipeView.superview];
    // product header view visibility
    productHeaderView.imageSwipeView.hidden = YES;
    // hide replaced view controller
    fromViewController.view.hidden = YES;
    
    toViewController.view.alpha = self.toVCAlphaStart;
    
    if(![toViewController conformsToProtocol:@protocol(BFProductZoomAnimatorDelegate)]) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    UICollectionViewCell *cell;
    if([toViewController isKindOfClass:[BFWishlistViewController class]]) {
        cell = [((id<BFProductZoomAnimatorDelegate>)toViewController)collectionViewCellForItem:(BFWishlistItem *)((BFProductDetailViewController *)fromViewController).wishlistItem];
    }
    else {
        cell = [((id<BFProductZoomAnimatorDelegate>)toViewController)collectionViewCellForItem:(BFProduct *)((BFProductDetailViewController *)fromViewController).product];
    }

    if(!cell) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    // product image view
    UIImageView *cellImageView = ((BFCollectionViewCell *)cell).imageContentView;
    // hide incoming view
    cellImageView.alpha = 0.0f;
    
    // replacing view controller final frame
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    // add transition subviews
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect cellImageViewframe = [containerView convertRect:cellImageView.frame fromView:cellImageView.superview];
        // update alpha to fade in
        toViewController.view.alpha = 0.6f;
        CGFloat aspectSize = CGRectGetHeight(cellImageViewframe) / CGRectGetHeight(imageSnapshot.frame);
        CGFloat destinationWidth = aspectSize * CGRectGetWidth(imageSnapshot.frame);
        CGRect destinationRect = CGRectMake(CGRectGetMidX(cellImageViewframe)-destinationWidth/2, CGRectGetMinY(cellImageViewframe), destinationWidth, CGRectGetHeight(cellImageViewframe));

        // move the product image
        imageSnapshot.frame = destinationRect;
    } completion:^(BOOL finished) {
        // remove snapshot
        [imageSnapshot removeFromSuperview];
        // set full alpha
        cellImageView.alpha = self.toVCAlphaEnd;
        // product header view visibility
        productHeaderView.imageSwipeView.hidden = NO;
        // show replaced view controller
        fromViewController.view.hidden = NO;
        toViewController.view.alpha = 1.0f;
        // finish transition
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}



@end
