//
//  BFOrdersTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFOrder.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOrdersTableViewCellExtension` manages orders history displaying in a table view.
 */
@interface BFOrdersTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Orders datasource.
 */
@property (nonatomic, strong) NSArray<BFOrder *> *orders;
/**
 * Flag indicating the loading footer view visibility.
 */
@property (nonatomic, assign) BOOL showsFooter;


@end

NS_ASSUME_NONNULL_END


