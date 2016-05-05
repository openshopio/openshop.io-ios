//
//  BFOnboardingLanguageContentViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

#import "BFOnboardingContentViewController.h"

@class BFShop, BFAlignedImageButton;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOnboardingLanguageContentViewController` controls shop language page view presented during
 * the user onboarding process.
 */
@interface BFOnboardingLanguageContentViewController : BFOnboardingContentViewController

/**
 * Select language button.
 */
@property (weak, nonatomic) IBOutlet BFAlignedImageButton *selectLanguageButton;
/**
 * Shop language views.
 */
@property (nonatomic, strong) NSArray<BFShop *> *languageItems;
/**
 * Continue button to go to next page.
 */
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

/**
 * Action to display Action Sheet Picker with language selection.
 *
 * @param sender The sender.
 */
- (IBAction)languageButtonAction:(id)sender;
/**
 * Go to next page with the selected language
 *
 * @param sender The sender.
 */
- (IBAction)continueButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
