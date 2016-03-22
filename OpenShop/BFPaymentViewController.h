//
//  BFPaymentViewController.h
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTableViewController.h"

@class BFCartPayment, BFOrderFormViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol BFShippingViewControllerDelegate;

/**
 * `BFPaymentViewControllerDelegate` handles selecting payment.
 */
@protocol BFPaymentViewControllerDelegate <NSObject>

/**
 * Delegate method which passes selected payment.
 */
- (void)paymentViewController:(BFViewController *)controller
            selectedPayment:(BFCartPayment *)selectedPayment;

@end

/**
 * `BFPaymentViewController` manages the part of the order
 * where user chooses between payment types.
 */
@interface BFPaymentViewController : BFTableViewController

/**
 * Delegate method which passes selected delivery.
 */
@property (nonatomic, weak) id <BFPaymentViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
