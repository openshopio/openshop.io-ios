//
//  BFModalViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFTableViewController.h"
#import "BFAppAppearance.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFModalViewController` is the base view controller extension establishing modal presentation.
 * It sets up user interface for modal view controller dismissal and it can be customized with
 * completion block.
 */
@interface BFModalViewController : BFTableViewController <BFCustomAppearance>

/**
 * The modal view controller pre dismissal completion block.
 */
@property (nonatomic, copy) void (^preCompletion)(void);
/**
 * The modal view controller post dismissal completion block.
 */
@property (nonatomic, copy) void (^postCompletion)(void);

/**
 * Animates the modal view controller dismissal.
 */
@property (nonatomic, assign) BOOL animatesDismissal;

/**
 * Dismisses the modal view controller with optional animation.
 *
 * @param animated The dismissal animation.
 */
- (void)dismissAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
