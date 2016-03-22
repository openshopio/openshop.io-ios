//
//  BFProductsNavigationController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductsNavigationController` extends `UINavigationController` with custom view controller
 * transition animations. It uses `BFViewControllerZoomInAnimator`, `BFViewControllerZoomOutAnimator`
 * and `BFViewControllerAlphaAnimator` for the navigation push and pop operations. It is mainly oriented
 * to be used for transitions between the products collection view and their detail view controller.
 */
@interface BFProductsNavigationController : UINavigationController <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

NS_ASSUME_NONNULL_END
