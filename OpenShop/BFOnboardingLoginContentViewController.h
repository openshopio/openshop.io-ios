//
//  BFOnboardingLoginContentViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

#import "BFOnboardingContentViewController.h"
#import "BFAlignedImageButton.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOnboardingLoginContentViewController` controls user login with email, facebook
 * login and the registration onboarding options view.
 */
@interface BFOnboardingLoginContentViewController : BFOnboardingContentViewController

/**
 * Login with email button.
 */
@property (nonatomic, weak) IBOutlet BFButton *emailButton;
/**
 * Facebook login button.
 */
@property (nonatomic, weak) IBOutlet BFButton *facebookButton;
/**
 * Registration button.
 */
@property (nonatomic, weak) IBOutlet BFAlignedImageButton *registerButton;

@end

NS_ASSUME_NONNULL_END
