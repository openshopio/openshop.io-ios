//
//  BFShippingViewController.h
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTableViewController.h"

@class BFDeliveryInfo, BFCartDelivery, BFCartPayment, BFOrderFormViewController;

@protocol BFPaymentViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFShippingViewControllerDelegate` handles selecting delivery info.
 */
@protocol BFShippingViewControllerDelegate <NSObject>

/**
 * Delegate method which passes back selected delivery.
 */
- (void)shippingViewController:(BFViewController *)controller
            selectedShipping:(BFCartDelivery *)selectedShipping;

@end

/**
 * `BFShippingViewController` manages the part of the order
 * where user chooses between shipping types.
 */
@interface BFShippingViewController : BFTableViewController

/**
 * Delegate method which passes selected delivery.
 */
@property (nonatomic, weak) id <BFShippingViewControllerDelegate> delegate;
/**
 * Delivery items.
 */
@property (nullable, nonatomic, strong) BFDeliveryInfo *deliveryInfo;
/**
 * Order Form which presented this view controller.
 */
@property (nullable, nonatomic, strong) BFOrderFormViewController *orderFormController;

@end

NS_ASSUME_NONNULL_END
