//
//  BFSearchSuggestionsTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 16.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"
#import "BFSearchSuggestion.h"
#import "BFSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFSearchSuggestionsTableViewCellExtension` manages search queries suggestions displaying in a table view.
 */
@interface BFSearchSuggestionsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Search queries data source.
 */
@property (nonatomic, strong) NSMutableArray<BFSearchSuggestion *> *searchSuggestions;
/**
 * Table view controller managing table view presenting contents of this extension 
 * which conforms to the `BFSearchViewControllerDelegate` protocol.
 */
@property (nonatomic, strong) BFTableViewController<BFSearchViewControllerDelegate> *tableViewController;

@end

NS_ASSUME_NONNULL_END
