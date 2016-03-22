//
//  BFViewControllerPushAnimator.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewControllerPushAnimator.h"

/**
 * View controller transition default duration.
 */
static double const BFViewControllerPushAnimationDefaultDuration = 0.25;


@interface BFViewControllerPushAnimator ()

@end


@implementation BFViewControllerPushAnimator


#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.duration = BFViewControllerPushAnimationDefaultDuration;
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // replacing view controller
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // view attaching
    [[transitionContext containerView] addSubview:toViewController.view];
    // replacing controller starting alpha
    toViewController.view.alpha = self.toVCAlphaStart;
    
    // alpha animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // replacing controller ending alpha
        toViewController.view.alpha = self.toVCAlphaEnd;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}





@end
