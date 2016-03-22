//
//  BFViewControllerProductZoomInAnimator.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewControllerProductZoomInAnimator.h"
#import "BFCollectionViewController.h"
#import "BFCollectionViewCell.h"
#import "BFProductDetailViewController.h"

@interface BFViewControllerProductZoomInAnimator ()


@end


@implementation BFViewControllerProductZoomInAnimator


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // replacing view controller
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // replaced view controller
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if(![fromViewController isKindOfClass:[BFCollectionViewController class]] && ![toViewController isKindOfClass:[BFProductDetailViewController class]]) {
        [transitionContext completeTransition:YES];
        return;
    }
    UICollectionView *collectionView = ((BFCollectionViewController *)fromViewController).collectionView;
    
    // selected product index path
    NSIndexPath *indexPath = [[collectionView indexPathsForSelectedItems] firstObject];
    // selected product table view cell
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if(![cell isKindOfClass:[BFCollectionViewCell class]]) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    // product image view
    UIImageView *cellImageView = ((BFCollectionViewCell *)cell).imageContentView;
    
    // product image snapshot
    UIView *cellImageSnapshot = [cellImageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:cellImageView.frame fromView:cellImageView.superview];
    // hide product image
    cellImageView.hidden = YES;
    
    // initial view states
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = self.toVCAlphaStart;
    // product header view content visibility
    BFProductDetailHeaderView *productHeaderView = ((BFProductDetailViewController *)toViewController).headerView;
    productHeaderView.imageSwipeView.hidden = YES;
    productHeaderView.nameLabel.hidden = YES;
    productHeaderView.priceLabel.hidden = YES;

    // hide replaced view controller
    fromViewController.view.hidden = YES;
    
    // add transition subviews
    [containerView setBackgroundColor:[UIColor whiteColor]];
    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // fade in the replacing view controller's view
        toViewController.view.alpha = self.toVCAlphaEnd;
        
        // images swipe view frame
        CGRect imageSwipeViewFrame = [containerView convertRect:productHeaderView.imageSwipeView.frame fromView:toViewController.view];
        // image snapshot frame calculation
        CGFloat aspectSize = CGRectGetHeight(imageSwipeViewFrame) / CGRectGetHeight(cellImageSnapshot.frame);
        CGFloat destinationWidth = aspectSize * CGRectGetWidth(cellImageSnapshot.frame);
        CGRect destinationRect = CGRectMake(CGRectGetMaxX(imageSwipeViewFrame)/2-destinationWidth/2, CGRectGetMinY(imageSwipeViewFrame), destinationWidth, CGRectGetHeight(imageSwipeViewFrame));
        cellImageSnapshot.frame = destinationRect;
    } completion:^(BOOL finished) {
        // product header view content visibility
        productHeaderView.imageSwipeView.hidden = NO;
        productHeaderView.nameLabel.hidden = NO;
        productHeaderView.priceLabel.hidden = NO;
        
        // show replaced view controller
        fromViewController.view.hidden = NO;
        
        // show product image
        cellImageView.hidden = NO;
        // remove snapshot
        [cellImageSnapshot removeFromSuperview];
        
        // finish transition
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}




@end
