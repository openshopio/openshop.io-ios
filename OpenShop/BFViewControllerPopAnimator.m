//
//  BFViewControllerPopAnimator.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewControllerPopAnimator.h"

/**
 * View controller transition default duration.
 */
static double const BFViewControllerPopAnimationDefaultDuration = 0.25;


@interface BFViewControllerPopAnimator ()


@end


@implementation BFViewControllerPopAnimator


#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.duration = BFViewControllerPopAnimationDefaultDuration;
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // replacing view controller
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // replaced view controller
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // replacing view controller starting alpha
    if(!self.modalPresentation) {
        toViewController.view.alpha = self.toVCAlphaStart;
    }
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    // alpha animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // replaced view controller ending alpha
        fromViewController.view.alpha = self.fromVCAlphaEnd;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}





@end
