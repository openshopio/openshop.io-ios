//
//  BFPushPopNavigationController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFPushPopNavigationController.h"
#import "BFViewControllerPopAnimator.h"
#import "BFViewControllerPushAnimator.h"


@implementation BFPushPopNavigationController


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
    }
    return self;
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
            return [[BFViewControllerPushAnimator alloc] init];
        case UINavigationControllerOperationPop:
            return [[BFViewControllerPopAnimator alloc] init];
        default:
            break;
    }
    
    return nil;
}


@end

