//
//  BFOrderSummaryProductsTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 24.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderSummaryProductsTableViewCellExtension` manages product cells within order summary.
 */
@interface BFOrderSummaryProductsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Refreshes product items and appends `BFOrderSummaryItemTotal`.
 */
- (void)setupItems;

@end

NS_ASSUME_NONNULL_END