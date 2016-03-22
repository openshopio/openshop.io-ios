//
//  BFViewControllerAnimator.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewControllerAnimator.h"

/**
 * View controller default transition duration.
 */
static double const BFViewControllerAnimationDefaultDuration = 0.3f;
/**
 * Replacing view controller default alpha value at transition start.
 */
static CGFloat const BFViewControllerAnimationFromVCDefaultAlphaStart = 1.0f;
/**
 * Replacing view controller default alpha value at the end of the transition.
 */
static CGFloat const BFViewControllerAnimationFromVCDefaultAlphaEnd = 0.0f;
/**
 * Replaced view controller default alpha value at transition start.
 */
static CGFloat const BFViewControllerAnimationToVCDefaultAlphaStart = 0.0f;
/**
 * Replaced view controller default alpha value at the end of the transition.
 */
static CGFloat const BFViewControllerAnimationToVCDefaultAlphaEnd = 1.0f;


@interface BFViewControllerAnimator ()


@end


@implementation BFViewControllerAnimator


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // method stub, should be implemented in the subclass
    [transitionContext completeTransition:YES];
}


#pragma mark - Properties Getters

- (double)duration {
    // if none set return default
    if (!_duration) {
        _duration = BFViewControllerAnimationDefaultDuration;
    }
    return _duration;
}

- (CGFloat)fromVCAlphaStart {
    // if none set return default
    if (!_fromVCAlphaStart) {
        _fromVCAlphaStart = BFViewControllerAnimationFromVCDefaultAlphaStart;
    }
    return _fromVCAlphaStart;
}

- (CGFloat)fromVCAlphaEnd {
    // if none set return default
    if (!_fromVCAlphaEnd) {
        _fromVCAlphaEnd = BFViewControllerAnimationFromVCDefaultAlphaEnd;
    }
    return _fromVCAlphaEnd;
}

- (CGFloat)toVCAlphaStart {
    // if none set return default
    if (!_toVCAlphaStart) {
        _toVCAlphaStart = BFViewControllerAnimationToVCDefaultAlphaStart;
    }
    return _toVCAlphaStart;
}

- (CGFloat)toVCAlphaEnd {
    // if none set return default
    if (!_toVCAlphaEnd) {
        _toVCAlphaEnd = BFViewControllerAnimationToVCDefaultAlphaEnd;
    }
    return _toVCAlphaEnd;
}




@end
