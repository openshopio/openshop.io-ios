//
//  BFOrderShippingTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderShippingTableViewCellExtension` manages order shipping cells.
 */
@interface BFShippingTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Delivery data source.
 */
@property (nonatomic, strong) NSArray<BFCartDelivery *> *shippingItems;
/**
 * Completion block called if the cell was selected.
 */
@property (nonatomic, copy) void (^didSelectDeliveryBlock)(BFCartDelivery *);

@end

NS_ASSUME_NONNULL_END