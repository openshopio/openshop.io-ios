//
//  BFOnboardingRegistrationViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

#import "BFOnboardingRegistrationViewController.h"
#import "BFFormSheetViewController.h"
#import "BFButton.h"
#import "BFNCheckmarkView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOnboardingRegistrationViewController` controls user registration. It is designed to be presented
 * as a form sheet popover.
 */
@interface BFOnboardingRegistrationViewController : BFFormSheetViewController <UITextFieldDelegate>

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
 * User registration submit button.
 */
@property (nonatomic, weak) IBOutlet BFButton *registerButton;
/**
 * Man gender checkmark text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *checkmarkManLabel;
/**
 * Man gender checkmark view.
 */
@property (nonatomic, weak) IBOutlet BFNCheckmarkView *checkmarkMan;
/**
 * Woman gender checkmark text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *checkmarkWomanLabel;
/**
 * Woman gender checkmark view.
 */
@property (nonatomic, weak) IBOutlet BFNCheckmarkView *checkmarkWoman;

@end

NS_ASSUME_NONNULL_END


