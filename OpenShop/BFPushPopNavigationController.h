//
//  BFPushPopNavigationController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFPushPopNavigationController` extends `UINavigationController` with custom view controller
 * transition animations. It uses `BFViewControllerPushAnimator` and `BFViewControllerPopAnimator`
 * for the navigation push and pop operations.
 */
@interface BFPushPopNavigationController : UINavigationController <UINavigationControllerDelegate>

@end

NS_ASSUME_NONNULL_END
