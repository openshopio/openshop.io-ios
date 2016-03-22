//
//  UIWindow+BFOverlays.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOverlays` category of UIWindow extends window capability to present a custom overlay and
 * toast notifications.
 */

@interface UIWindow (BFOverlays)


#pragma mark - Progress & Result Overlays

/**
 * Shows indeterminate small progress indicator overlay with optional title and animated transition.
 *
 * @param title The overlay title.
 * @param animated The animated transition.
 */
- (void)showIndeterminateSmallProgressOverlayWithTitle:(nullable NSString *)title animated:(BOOL)animated;
/**
 * Shows indeterminate progress indicator overlay with optional title and animated transition.
 *
 * @param title The overlay title.
 * @param animated The animated transition.
 */
- (void)showIndeterminateProgressOverlayWithTitle:(nullable NSString *)title animated:(BOOL)animated;
/**
 * Shows success checkmark indicator overlay with optional title and animated transition.
 *
 * @param title The overlay title.
 * @param animated The animated transition.
 */
- (void)showSuccessOverlayWithTitle:(nullable NSString *)title animated:(BOOL)animated;
/**
 * Shows failure cross indicator overlay with optional title and animated transition.
 *
 * @param title The overlay title.
 * @param animated The animated transition.
 */
- (void)showFailureOverlayWithTitle:(nullable NSString *)title animated:(BOOL)animated;
/**
 * Dismisses all overlays with optionally animated transition and completion block.
 *
 * @param completionBlock The block called when the dismiss completes.
 * @param animated The animated transition.
 */
- (void)dismissAllOverlaysWithCompletion:(nullable void(^)())completionBlock animated:(BOOL)animated;
/**
 * Dismisses all overlays with optionally animated transition and completion block after time delay (seconds).
 *
 * @param completionBlock The block called when the dismiss completes.
 * @param animated The animated transition.
 * @param delay The time delay.
 */
- (void)dismissAllOverlaysWithCompletion:(nullable void(^)())completionBlock animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;


#pragma mark - Toast Notifications

/**
 * Shows toast notification to be shown with warning message, notification options and completion block.
 *
 * @param message The toast warning message.
 * @param options The toast notification options.
 * @param completionBlock The block called when the toast has been presented.
 */
- (void)showToastWarningMessage:(NSString *)message withOptions:(nullable NSDictionary *)options completion:(nullable void(^)())completionBlock;
/**
 * Shows toast notification to be shown with warning message and completion block.
 *
 * @param message The toast warning message.
 * @param completionBlock The block called when the toast has been presented.
 */
- (void)showToastWarningMessage:(NSString *)message withCompletion:(nullable void(^)())completionBlock;
/**
 * Shows toast notification to be shown with message, notification options and completion block.
 *
 * @param message The toast message.
 * @param options The toast notification options.
 * @param completionBlock The block called when the toast has been presented.
 */
- (void)showToastMessage:(NSString *)message withOptions:(nullable NSDictionary *)options completion:(nullable void(^)())completionBlock;
/**
 * Shows toast notification to be shown with message and completion block.
 *
 * @param message The toast message.
 * @param completionBlock The block called when the toast has been presented.
 */
- (void)showToastMessage:(NSString *)message withCompletion:(nullable void(^)())completionBlock;



@end

NS_ASSUME_NONNULL_END
