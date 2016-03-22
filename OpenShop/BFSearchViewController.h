//
//  BFSearchViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Search delegate used to performs searches.
 */
@protocol BFSearchViewControllerDelegate <NSObject>

@optional
/**
 * Performs search query request with presenting the results.
 * @param searchQuery The search query to be performed.
 */
- (void)performSearchQueryRequest:(NSString *)searchQuery;

@end


/**
 * `BFSearchViewController` displays search interface for products.
 */
@interface BFSearchViewController : BFTableViewController <BFCustomAppearance, UISearchBarDelegate, BFSearchViewControllerDelegate>

/**
 * The search bar.
 */
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END


