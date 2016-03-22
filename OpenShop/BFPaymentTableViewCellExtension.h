//
//  BFOrderPaymentTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 24.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

@class BFCartPayment;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFPaymentTableViewCellExtension` manages payment section in Payment View Controller.
 */
@interface BFPaymentTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Payment items data source.
 */
@property (nonatomic, strong) NSArray<BFCartPayment *> *paymentItems;
/**
 * Completion block called if the cell was selected.
 */
@property (nonatomic, copy) void (^didSelectPaymentBlock)(BFCartPayment *);

@end

NS_ASSUME_NONNULL_END
