//
//  BFViewControllerAlphaAnimator.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewControllerAlphaAnimator.h"



@interface BFViewControllerAlphaAnimator ()


@end


@implementation BFViewControllerAlphaAnimator


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // replacing view controller
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // replaced view controller
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    // initial view states
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    // initial alpha values
    fromViewController.view.alpha = self.fromVCAlphaStart;
    toViewController.view.alpha = self.toVCAlphaStart;
    
    // alpha animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // final alpha values
        fromViewController.view.alpha = self.fromVCAlphaEnd;
        toViewController.view.alpha = self.toVCAlphaEnd;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];    
}





@end
