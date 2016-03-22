//
//  UIAlertController+BFError.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFError.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFError` category of UIAlertController adds ability to present error description with possible
 * recovery options. Recovery options are connected to a recovery attempter specified in `BFError`.
 * Every recovery option corresponds to the alert controller action.
 */
@interface UIAlertController (BFError)


/**
 * Creates an alert controller with a specified error, style and completion block to be executed when the
 * alert controller was dismissed.
 *
 * @param error The error information.
 * @param preferredStyle The alert controller style (UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert).
 * @param block The completion block.
 * @return The newly-initialized `UIAlertController`.
 */
+ (instancetype)alertControllerWithError:(BFError *)error preferredStyle:(UIAlertControllerStyle)preferredStyle completionBlock:(nullable BFErrorCompletionBlock)block;

@end

NS_ASSUME_NONNULL_END
