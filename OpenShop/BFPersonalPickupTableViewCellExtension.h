//
//  BFOrderPersonalPickupTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFPersonalPickupTableViewCellExtension` manages order personal pickup cells.
 */
@interface BFPersonalPickupTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Delivery data source.
 */
@property (nonatomic, strong) NSArray<BFCartDelivery *> *personalPickupItems;
/**
 * Completion block called if the cell was selected.
 */
@property (nonatomic, copy) void (^didSelectDeliveryBlock)(BFCartDelivery *);

/**
 * Manually select branch.
 */
- (void)didSelectBranch:(BFBranch *)branch;

@end

NS_ASSUME_NONNULL_END