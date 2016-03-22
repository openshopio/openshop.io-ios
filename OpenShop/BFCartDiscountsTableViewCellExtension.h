//
//  BFCartDiscountsTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 30.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

@class BFCartDiscountItem;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFCartDiscountsTableViewCellExtension` manages discount cells in cart.
 */
@interface BFCartDiscountsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * The discount removal started block callback.
 */
@property (nonatomic, copy) void (^discountRemovalDidBeginCallback)();
/**
 * The discount removal finished block callback.
 */
@property (nonatomic, copy) void (^discountRemovalDidFinishCallback)(NSError *error);

@end

NS_ASSUME_NONNULL_END