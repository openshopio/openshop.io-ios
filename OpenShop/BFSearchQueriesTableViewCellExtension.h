//
//  BFSearchQueriesTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFSearchQuery.h"
#import "BFSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFSearchQueriesTableViewCellExtension` manages search queries displaying in a table view.
 */
@interface BFSearchQueriesTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Search queries data source.
 */
@property (nonatomic, strong) NSMutableArray<BFSearchQuery *> *searchQueries;
/**
 * Search queries header view text.
 */
@property (nonatomic, copy) NSString *headerText;
/**
 * Flag indicating the table view cell swipe tutorial presentation.
 */
@property (nonatomic, assign) BOOL swipeTutorialEnabled;
/**
 * Flag indicating whether the user is allowed to remove the search query.
 */
@property (nonatomic, assign) BOOL removalEnabled;
/**
 * Table view controller managing table view presenting contents of this extension
 * which conforms to the `BFSearchViewControllerDelegate` protocol.
 */
@property (nonatomic, strong) BFTableViewController<BFSearchViewControllerDelegate> *tableViewController;

@end



NS_ASSUME_NONNULL_END


