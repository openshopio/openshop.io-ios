//
//  BFTableViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "BFDataViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BFTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
* `BFTableViewCellExtensionDelegate` is a protocol specifying table view extension
* callback methods to perform a view controller transition or any interaction with
* another table view extensions.
*/
@protocol BFTableViewCellExtensionDelegate <BFDataExtensionDelegate>

@optional

/**
 * Deselects table view row at index on extension.
 *
 * @param index The table view row index.
 * @param extension The table view extension.
 */
- (void)deselectRowAtIndex:(NSInteger)index onExtension:(id)extension;

/**
 * Reloads table view cell extensions content with row animation.
 *
 * @param extensions The table view cell extensions.
 * @param rowAnimation The table view row animation.
 */
- (void)reloadExtensions:(NSArray<id<BFTableViewCellExtension>> *)extensions withRowAnimation:(UITableViewRowAnimation)rowAnimation;

@end


/**
 * `BFTableViewController` is a base view controller to add support for table view.
 * It manages table view extensions implementing table view sections content. This
 * controller is also an empty data source and data set delegate which is inherited
 * from the parent `BFDataViewController`.
 */
@interface BFTableViewController : BFDataViewController <BFCustomAppearance, BFTableViewCellExtensionDelegate, UITableViewDelegate, UITableViewDataSource>

/**
 * Table view.
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/**
 * Checks if the indexPath is available in the current table view.
 *
 * @param indexPath IndexPath to check.
 * @return YES if the indexPath is present, otherwise NO
 *
 */
- (BOOL)isIndexPathPresentInTableView:(NSIndexPath *)indexPath;
/**
 * IndexPath for the given row and extension.
 *
 * @param index The table view cell index.
 * @param extension The table view cell extensions.
 * @return IndexPath for the row and extension
 *
 */
- (NSIndexPath *)indexPathForIndexRowAtIndex:(NSInteger)index extension:(id<BFTableViewCellExtension>)extension;


@end

NS_ASSUME_NONNULL_END


