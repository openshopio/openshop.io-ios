//
//  BFOrderFormViewController.h
//  OpenShop
//
//  Created by Petr Škorňok on 18.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTableViewController.h"
#import "BFPaymentViewController.h"
#import "BFShippingViewController.h"

@class BFAlignedImageButton;
@class BFDeliveryInfo;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderFormViewController` displays order form.
 */
@interface BFOrderFormViewController : BFTableViewController <BFShippingViewControllerDelegate, BFPaymentViewControllerDelegate>

/**
 * License agreement label.
 */
@property (weak, nonatomic) IBOutlet UILabel *licenseAgreementLabel;
/**
 * Total price label.
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/**
 * Vat included label.
 */
@property (weak, nonatomic) IBOutlet UILabel *vatIncludedLabel;
/**
 * Order button.
 */
@property (weak, nonatomic) IBOutlet BFAlignedImageButton *summaryButton;
/**
 * Shipping & payment objects.
 */
@property (nonatomic, strong) BFDeliveryInfo *deliveryInfo;

@end

NS_ASSUME_NONNULL_END
