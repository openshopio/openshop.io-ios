//
//  BFInitViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFInitViewController` is the application initial view controller. It works as a directory
 * presenting other view controllers based on the user's onboarding and login state.
 */
@interface BFInitViewController : UIViewController

/**
 * Launch screen image.
 */
@property (nonatomic, weak) IBOutlet UIImageView *launchImageView;

@end

NS_ASSUME_NONNULL_END