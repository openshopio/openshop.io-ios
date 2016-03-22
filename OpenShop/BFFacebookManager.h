//
//  BFFacebookManager.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Facebook API request completion block type.
 */
typedef void (^BFFacebookCompletionBlock)(NSDictionary *_Nullable response, NSError *_Nullable error);


/**
 * `BFFacebookManager` subclasses `FBSDKLoginManager` to integrate methods for information retrieval
 *  from Facebook. It manages user login requests and information requests from Facebook Graph API.
 */
@interface BFFacebookManager : FBSDKLoginManager

/**
 * Class method to access the static Facebook manager instance.
 *
 * @return Singleton instance of the `BFFacebookManager` class.
 */
+ (instancetype)sharedManager;

/**
 * Requests user Facebook login and basic information retrieval.
 *
 * @param viewController The view controller to present Facebook login view from.
 * @param block The block to call when the request completes.
 */
- (void)logInFromViewController:(UIViewController *)viewController withCompletionBlock:(BFFacebookCompletionBlock)block;


@end

NS_ASSUME_NONNULL_END
