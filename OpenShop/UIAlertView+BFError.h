//
//  UIAlertView+BFError.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFError.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFError` category of UIAlertView adds ability to present error description with possible
 * recovery options. Recovery options are connected to a recovery attempter specified in
 * `BFError`. Every recovery option corresponds to the alert view button.
 */
@interface UIAlertView (BFError)

/**
 * Creates an alert view with a specified error and completion block to be executed when the
 * alert view was dismissed.
 *
 * @param error The error information.
 * @param block The completion block.
 * @return The newly-initialized `UIAlertView`.
 */
- (instancetype)initWithError:(BFError *) error completionBlock:(nullable BFErrorCompletionBlock)block;

@end

NS_ASSUME_NONNULL_END
