//
//  BFOrderDetailsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFOrder.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrderDetailsTableViewCellExtension` displays order information details.
 */
@interface BFOrderDetailsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * The order data model.
 */
@property (nonatomic, strong) BFOrder *order;
/**
 * Flag indicating whether the order details are being fetched.
 */
@property (nonatomic, assign) BOOL finishedLoading;

@end

NS_ASSUME_NONNULL_END


