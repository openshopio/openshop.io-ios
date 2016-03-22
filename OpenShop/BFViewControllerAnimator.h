//
//  BFViewControllerAnimator.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFViewControllerAnimator` represent a custom view controller animator base class. It encapsulates
 * all the basic animation properties and should be subclassed for further use.
 */
@interface BFViewControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * View controller transition duration.
 */
@property (nonatomic, assign) double duration;
/**
 * Replacing view controller alpha value at transition start.
 */
@property (nonatomic, assign) CGFloat fromVCAlphaStart;
/**
 * Replacing view controller alpha value at the end of the transition.
 */
@property (nonatomic, assign) CGFloat fromVCAlphaEnd;
/**
 * Replaced view controller alpha value at transition start.
 */
@property (nonatomic, assign) CGFloat toVCAlphaStart;
/**
 * Replaced view controller alpha value at the end of the transition.
 */
@property (nonatomic, assign) CGFloat toVCAlphaEnd;
/**
 * Modal view controller custom transition animation.
 */
@property (nonatomic, assign) BOOL modalPresentation;


@end

NS_ASSUME_NONNULL_END
