//
//  BFOrderSentViewController.h
//  OpenShop
//
//  Created by Petr Škorňok on 11.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFFormSheetViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderSentViewController` is designed to be presented as a form sheet
 *  popover which informs the user that his order has been sent.
 */
@interface BFOrderSentViewController : BFFormSheetViewController

/**
 * Label which presents title text.
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 * Label which presents subtitle text.
 */
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/**
 * Button which dismisses this view.
 */
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

NS_ASSUME_NONNULL_END
