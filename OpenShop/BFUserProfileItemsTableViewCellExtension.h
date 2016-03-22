//
//  BFUserProfileItemsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFUserProfileItemsTableViewCellExtension` manages user profile items displaying in a table view.
 */
@interface BFUserProfileItemsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Refreshes extension's data source.
 */
- (void)refreshDataSource;

@end



NS_ASSUME_NONNULL_END


