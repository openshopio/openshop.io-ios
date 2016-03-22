//
//  BFSearchQueriesTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSearchQueriesTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "UIFont+BFFont.h"
#import "BFProductsViewController.h"

/**
 * Search query table view cell reuse identifier.
 */
static NSString *const searchQueryCellReuseIdentifier         = @"BFSearchQueryTableViewCellIdentifier";
/**
 * Search queries header view reuse identifier.
 */
static NSString *const searchQueriesHeaderViewReuseIdentifier = @"BFSearchQueriesHeaderViewIdentifier";
/**
 * Search queries header view nib file name.
 */
static NSString *const searchQueriesHeaderViewNibName         = @"BFTableViewGroupedHeaderFooterView";
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo              = @"productInfo";
/**
 * Search query table view cell height.
 */
static CGFloat const searchQueryCellHeight                    = 42.0f;
/**
 * Search queries header view height.
 */
static CGFloat const searchQueriesHeaderViewHeight            = 50.0f;
/**
 * Search queries empty footer view height.
 */
static CGFloat const searchQueriesEmptyFooterViewHeight       = 15.0f;
/**
 * Table view cell swipe gesture tutorial offset.
 */
static CGFloat const cellSwipeOffset                          = -50.0f;
/**
 * Table view cell swipe gesture tutorial duration (seconds).
 */
static CGFloat const cellSwipeDuration                        = 0.5f;
/**
 * Table view cell swipe gesture tutorial delay (seconds).
 */
static CGFloat const cellSwipeDelay                           = 0.5f;



@interface BFSearchQueriesTableViewCellExtension ()



@end


@implementation BFSearchQueriesTableViewCellExtension

@dynamic tableViewController;

#pragma mark - Initialization

- (void)didLoad {
    // register header view
    [self.tableView registerNib:[UINib nibWithNibName:searchQueriesHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:searchQueriesHeaderViewReuseIdentifier];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.searchQueries count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return searchQueryCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:searchQueryCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchQueryCellReuseIdentifier];
    }
    
    // search query
    BFSearchQuery *searchQuery = [self.searchQueries objectAtIndex:index];
    // search query text
    [cell.headerlabel setText:searchQuery.query];
    
    // search query removal
    if(self.removalEnabled) {
        // setup swipe gesture
        __weak __typeof__(self) weakSelf = self;
        MGSwipeButton *deleteSwipeButton = [MGSwipeButton buttonWithTitle:BFLocalizedString(kTranslationDelete, @"Delete") backgroundColor:[UIColor BFN_pinkColor]
                                                                 callback:^BOOL(MGSwipeTableCell *sender) {
                                                                     NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:sender];
                                                                     BFSearchQuery *searchQuery = [weakSelf.searchQueries objectAtIndex:indexPath.row];
                                                                     // delete the search query with animation
                                                                     [weakSelf.tableView beginUpdates];
                                                                     
                                                                     // remove search query from the data source
                                                                     [[StorageManager defaultManager]deleteSearchQuery:searchQuery];
                                                                     [weakSelf.searchQueries removeObject:searchQuery];
                                                                     
                                                                     [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                     [weakSelf.tableView endUpdates];
                                                                     
                                                                     return true;
                                                                 }];
        deleteSwipeButton.titleLabel.font = [UIFont BFN_robotoMediumWithSize:14];
        // delete button to revealed with the swipe gesture
        cell.rightButtons = @[deleteSwipeButton];
        // show the cell swipe tutorial for the first row if enabled
        if (self.swipeTutorialEnabled && index == 0 && self.tableViewController.view.window) {
            [cell swipeWithOffset:cellSwipeOffset duration:cellSwipeDuration delay:cellSwipeDelay];
            self.swipeTutorialEnabled = false;
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:searchQueriesHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:searchQueriesHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:self.headerText];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return searchQueriesHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return searchQueriesEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // search query
    BFSearchQuery *searchQuery = [self.searchQueries objectAtIndex:index];

    // products for search query
    [self.tableViewController performSearchQueryRequest:searchQuery.query];
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
