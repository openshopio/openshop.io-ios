//
//  BFProductsNavigationController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductsNavigationController.h"
#import "BFViewControllerProductZoomOutAnimator.h"
#import "BFViewControllerProductZoomInAnimator.h"
#import "BFViewControllerAlphaAnimator.h"
#import "BFViewControllerPushAnimator.h"
#import "BFProductDetailViewController.h"
#import "BFProductsViewController.h"
#import "BFWishlistViewController.h"

@implementation BFProductsNavigationController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if ((self = [super initWithRootViewController:rootViewController])) {
        self.delegate = self;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    return self;
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
            return [self animationControllerForPushOperationFromViewController:fromVC toViewController:toVC];
        case UINavigationControllerOperationPop:
            return [self animationControllerForPopOperationFromViewController:fromVC toViewController:toVC];
        default:
            break;
    }
    
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPopOperationFromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    if([fromVC isKindOfClass:[BFProductDetailViewController class]] && [toVC isKindOfClass:[BFProductsViewController class]]) {
        return [[BFViewControllerProductZoomOutAnimator alloc] init];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPushOperationFromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    if(([fromVC isKindOfClass:[BFProductsViewController class]] || [fromVC isKindOfClass:[BFWishlistViewController class]]) &&
       [toVC isKindOfClass:[BFProductDetailViewController class]]) {
        return [[BFViewControllerProductZoomInAnimator alloc] init];
    }
    else if ([fromVC isKindOfClass:[BFProductDetailViewController class]] && [toVC isKindOfClass:[BFWishlistViewController class]]) {
        return [[BFViewControllerAlphaAnimator alloc] init];
    } 
    return nil;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // allow interactive pop gesture if there is a controller to be popped
    return (self.viewControllers.count > 1);
}


@end

