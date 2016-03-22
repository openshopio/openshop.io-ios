//
//  BFAPIRequestOrderInfo+BFValidation.h
//  OpenShop
//
//  Created by Petr Škorňok on 21.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAPIRequestOrderInfo.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * `BFValidation` category offers methods for `BFAPIRequestOrderInfo` validation
 */
@interface BFAPIRequestOrderInfo (BFValidation)

/*
 * Validates `BFAPIRequestOrderInfo`.
 */
- (BOOL)isValid;
/*
 * Validates `BFAPIRequestOrderInfo` and offers completion handlers if
 * part of the validation fails. At first is validated shipping and payment
 * and then address.
 */
- (BOOL)isValidWithIncompleteShippingPaymentHandler:(void(^)(BFShippingAndPaymentItem))incompleteShippingPaymentHandler
                           incompleteAddressHandler:(void(^)(BFAddressItem))incompleteAddressHandler;

@end

NS_ASSUME_NONNULL_END