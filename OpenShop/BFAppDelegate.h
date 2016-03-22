//
//  BFAppDelegate.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAppDelegate` represents the aplication starting point. It implements `UIApplicationDelegate`
 * to manage the application lifecycle events.
 */
@interface BFAppDelegate : UIResponder <UIApplicationDelegate>
/**
 * Application main window.
 */
@property (strong, nonatomic) UIWindow *window;


@end

NS_ASSUME_NONNULL_END
