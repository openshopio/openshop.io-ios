//
//  BFBaseTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFTableViewCellExtension.h"
#import "BFTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFBaseTableViewCellExtension` is the base table view cell extension. It contains
 * basic properties and initialization methods used by all descendants.
 */
@interface BFBaseTableViewCellExtension : NSObject <BFTableViewCellExtension>

/**
 * Table view presenting contents of this extension.
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 * Table view controller managing table view presenting contents of this extension.
 */
@property (nonatomic, strong) BFTableViewController *tableViewController;

@end

NS_ASSUME_NONNULL_END


