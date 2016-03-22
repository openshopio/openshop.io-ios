//
//  BFOnboardingLoginEmailViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

#import "BFOnboardingContentViewController.h"
#import "BFAlignedImageButton.h"
#import "BFFormSheetViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOnboardingLoginEmailViewController` controls user login with email. It is designed to be presented
 * as a form sheet popover with optional view change to be able reset user's password.
 */
@interface BFOnboardingLoginEmailViewController : BFFormSheetViewController <UITextFieldDelegate>

/**
 * Email input text field.
 */
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
/**
 * Password input text field.
 */
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
/**
 * Header text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/**
 * User login or password reset submit button.
 */
@property (nonatomic, weak) IBOutlet BFButton *confirmButton;
/**
 * Email login view and password reset view toggle button.
 */
@property (nonatomic, weak) IBOutlet BFButton *changeViewButton;
/**
 * Allows view change to the password reset option.
 */
@property (nonatomic, assign) BOOL allowsPasswordReset;

@end

NS_ASSUME_NONNULL_END


