//
//  BFPushNotificationViewController.h
//  OpenShop
//
//  Created by Petr Škorňok on 14.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFFormSheetViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFPushNotificationViewController` is designed to be presented as a form sheet
 *  popover which pre-asks the user if he wants to receive the APNS notifications.
 */
@interface BFPushNotificationViewController : BFFormSheetViewController

/**
 * Title label.
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 * Dismiss button.
 */
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
/**
 * Confirm button.
 */
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end

NS_ASSUME_NONNULL_END
