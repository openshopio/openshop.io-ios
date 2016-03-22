//
//  BFOrderItemsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFOrderItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderItemsTableViewCellExtension` manages order items (products) displaying in a table view.
 */
@interface BFOrderItemsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * The order items data source.
 */
@property (nonatomic, strong) NSArray<BFOrderItem *> *orderItems;


@end

NS_ASSUME_NONNULL_END


