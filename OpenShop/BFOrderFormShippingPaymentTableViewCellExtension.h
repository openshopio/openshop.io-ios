//
//  BFOrderAndPaymentTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 18.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

@class BFCartPayment, BFCartDelivery;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderFormShippingPaymentTableViewCellExtension` manages order and payment section in OrderForm.
 */
@interface BFOrderFormShippingPaymentTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Refreshes extension's data source.
 */
- (void)refreshDataSource;

@end


NS_ASSUME_NONNULL_END
