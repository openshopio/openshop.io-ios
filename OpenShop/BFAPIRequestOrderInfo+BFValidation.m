//
//  BFAPIRequestOrderInfo+BFValidation.m
//  OpenShop
//
//  Created by Petr Škorňok on 21.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAPIRequestOrderInfo+BFValidation.h"

@implementation BFAPIRequestOrderInfo (BFValidation)

- (BFAddressItem)incompleteAddressItem
{
    BFAddressItem incompleteItem = BFAddressItemUnkown;
    
    if (!self.name || !self.name.length) {
        incompleteItem = BFAddressItemName;
    } else if (!self.email || !self.email.length) {
        incompleteItem = BFAddressItemEmail;
    } else if (!self.addressStreet || !self.addressStreet.length) {
        incompleteItem = BFAddressItemStreet;
    } else if (!self.addressHouseNumber || !self.addressHouseNumber.length) {
        incompleteItem = BFAddressItemHouseNumber;
    } else if (!self.addressCity || !self.addressCity.length) {
        incompleteItem = BFAddressItemCity;
    } else if (!self.addressPostalCode || !self.addressPostalCode.length) {
        incompleteItem = BFAddressItemPostalCode;
    } else if (!self.phone || !self.phone.length) {
        incompleteItem = BFAddressItemPhoneNumber;
    }
    
    return incompleteItem;
}

- (BFShippingAndPaymentItem)incompleteShippingPaymentItem
{
    BFShippingAndPaymentItem incompleteItem = BFShippingAndPaymentItemUnkown;
    
    if (!self.shippingID) {
        incompleteItem = BFShippingAndPaymentItemShipping;
    } else if (!self.paymentID) {
        incompleteItem = BFShippingAndPaymentItemPayment;
    }
    
    return incompleteItem;
}

- (BOOL)isValid
{
    BOOL isValid = YES;
    if ([self incompleteAddressItem] || [self incompleteShippingPaymentItem]) {
        isValid = NO;
    }
    return isValid;
}

- (BOOL)isValidWithIncompleteShippingPaymentHandler:(void(^)(BFShippingAndPaymentItem))incompleteShippingPaymentHandler incompleteAddressHandler:(void(^)(BFAddressItem))incompleteAddressHandler {
    BOOL isValid = YES;
    BFAddressItem incompleteAddressItem = [self incompleteAddressItem];
    BFShippingAndPaymentItem incompleteShippingPaymentItem = [self incompleteShippingPaymentItem];
    
    if (incompleteShippingPaymentItem) {
        isValid = NO;
        if (incompleteShippingPaymentHandler) {
            incompleteShippingPaymentHandler(incompleteShippingPaymentItem);
        }
    }
    else if (incompleteAddressItem) {
        isValid = NO;
        if (incompleteAddressHandler) {
            incompleteAddressHandler(incompleteAddressItem);
        }
    }
    return isValid;

}

@end
