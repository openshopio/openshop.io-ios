//
//  BFTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFDataExtension.h"
@class BFTableViewController;

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFTableViewCellExtension` is a protocol specifying required table view datasource and delegate
 * methods to provide table view section content and its properties.
 */
@protocol BFTableViewCellExtension <BFDataExtension>

@required

/**
 * Table view controller finished loading. This method should be executed before the table view displays.
 */
- (void)didLoad;
/**
 * Number of rows in the table view section.
 *
 * @return The number of rows.
 */
- (NSUInteger)getNumberOfRows;
/**
 * Height for row at index in the table view section.
 *
 * @param index The row index.
 * @return The row height.
 */
- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index;
/**
 * Table view cell for row at index in the table view section.
 *
 * @param index The row index.
 * @return The table view cell.
 */
- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index;

@optional

/**
 * Extension initialization with parent table view controller.
 *
 * @param viewController The parent table view controller.
 * @return The newly-initialized class implementing `BFTableViewCellExtension` protocol.
 */
- (instancetype)initWithTableViewController:(BFTableViewController *)viewController;
/**
 * Extension initialization with table view where is the extension's content presented.
 *
 * @param tableView The table view.
 * @return The newly-initialized class implementing `BFTableViewCellExtension` protocol.
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 * Table view section header view.
 *
 * @return The header view.
 */
- (UIView*)getHeaderView;
/**
 * Table view section header view height.
 *
 * @return The header height.
 */
- (CGFloat)getHeaderHeight;
/**
 * Table view section footer view.
 *
 * @return The footer view.
 */
- (UIView*)getFooterView;
/**
 * Table view section footer view height.
 *
 * @return The footer height.
 */
- (CGFloat)getFooterHeight;
/**
 * Table view cell at index in the table view section will be displayed.
 *
 * @param cell The cell to be displayed.
 * @param index The row index.
 */
- (void)willDisplayCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
/**
 * Table view cell at index in the table view section will be selected.
 *
 * @param index The row index.
 */
- (void)willSelectRowAtIndex:(NSInteger)index;
/**
 * Table view row at index in the table view section was selected.
 *
 * @param index The row index.
 */
- (void)didSelectRowAtIndex:(NSInteger)index;
/**
 * Table view row at index in the table view section was deselected.
 */
- (void)didDeselectRowAtIndex:(NSInteger)index;
/**
 * Estimated height for row at index in the table view section.
 *
 * @param index The row index.
 * @return The row estimated height.
 */
- (CGFloat)getEstimatedHeightForRowAtIndex:(NSUInteger)index;
/**
 * Table view section header view estimated height.
 *
 * @return The header view estimated height.
 */
- (CGFloat)getHeaderEstimatedHeight;
/**
 * Table view section footer view estimated height.
 *
 * @return The footer view estimated height.
 */
- (CGFloat)getFooterEstimatedHeight;
/**
 * Table view accessory button at index in the table view section was tapped.
 */
- (void)accessoryButtonTappedForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END


