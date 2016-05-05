//
//  BFSearchViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSearchViewController.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"
#import "BFSearchQueriesTableViewCellExtension.h"
#import "BFSearchSuggestionsTableViewCellExtension.h"
#import "MGSwipeTableCell+BFNSwipeGestureTutorial.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "BFProductsViewController.h"

/**
 * Storyboard products segue identifier.
 */
static NSString *const productsSegueIdentifier             = @"productsSegue";
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo           = @"productInfo";
/**
 * Maximum number of search suggestions displayed.
 */
static NSUInteger const numOfSearchSuggestions             = 5;
/**
 * Maximum number of last searched queries displayed.
 */
static NSUInteger const numOfLastSearchedQueries           = 3;
/**
 * Maximum number of most searched queries displayed.
 */
static NSUInteger const numOfMostSearchedQueries           = 3;
/**
 * Minimum number of search query occurences to be displayed as the most searched query.
 */
static NSUInteger const minOccurencesOfMostSearchedQueries = 3;


@interface BFSearchViewController ()

/**
 * Search suggestions table view cell extension.
 */
@property (nonatomic, strong) BFSearchSuggestionsTableViewCellExtension *searchSuggestionsExtension;
/**
 * Last searched queries table view cell extension.
 */
@property (nonatomic, strong) BFSearchQueriesTableViewCellExtension *lastSearchedQueriesExtension;
/**
 * Most searched queries table view cell extension.
 */
@property (nonatomic, strong) BFSearchQueriesTableViewCellExtension *mostSearchedQueriesExtension;
/**
 * Flag indicating the table view cell swipe tutorial presentation.
 */
@property (nonatomic, assign) BOOL swipeTutorialEnabled;
/**
 * Search text from search bar.
 */
@property (nonatomic, strong) NSString *searchText;

@end


@implementation BFSearchViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationSearch, @"Search") uppercaseString];
    // search bar
    self.searchBar.placeholder = BFLocalizedString(kTranslationWhoSeeksFinds, @"Who seeks finds");
    // table view cell swipe tutorial
    self.swipeTutorialEnabled = true;
    
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // language changed notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChangedAction) name:BFLanguageDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // clear search bar
    self.searchBar.text = nil;
    self.searchText = nil;
    // setup table view cell extensions
    [self setupExtensions];
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // search suggestions
    [self updateSearchSuggestionsExtension];
    
    // search queries
    [self updateSearchQueriesExtensions];
    
    // refresh displayed data
    [self.tableView reloadData];
}

- (void)updateSearchQueriesExtensions {
    // last searched queries
    NSArray *searchQueries = [[StorageManager defaultManager]findLastSearchedQueriesWithLimit:@(numOfLastSearchedQueries)];
    if(searchQueries.count) {
        _lastSearchedQueriesExtension = [[BFSearchQueriesTableViewCellExtension alloc]initWithTableViewController:self];
        _lastSearchedQueriesExtension.searchQueries = [[NSMutableArray alloc]initWithArray:searchQueries];
        _lastSearchedQueriesExtension.headerText = BFLocalizedString(kTranslationLastSearchedQueries, @"Last searched queries");
        _lastSearchedQueriesExtension.removalEnabled = true;
        _lastSearchedQueriesExtension.swipeTutorialEnabled = self.swipeTutorialEnabled;
        
        if (![self containsExtension:_lastSearchedQueriesExtension]) {
            [self addExtension:_lastSearchedQueriesExtension];
        }
        // table view cell swipe tutorial
        self.swipeTutorialEnabled = false;
    }
    
    // most searched queries
    searchQueries = [[StorageManager defaultManager]findMostSearchedQueriesWithLimit:@(numOfMostSearchedQueries) minOccurences:@(minOccurencesOfMostSearchedQueries)];
    if(searchQueries.count) {
        _mostSearchedQueriesExtension = [[BFSearchQueriesTableViewCellExtension alloc]initWithTableViewController:self];
        _mostSearchedQueriesExtension.searchQueries = [[NSMutableArray alloc]initWithArray:searchQueries];
        _mostSearchedQueriesExtension.headerText = BFLocalizedString(kTranslationMostSearchedQueries, @"Most searched queries");
        
        if (![self containsExtension:_mostSearchedQueriesExtension]) {
            [self addExtension:_mostSearchedQueriesExtension];
        }
    }
}

- (void)updateSearchSuggestionsExtension {
    NSArray *searchSuggestions = [[StorageManager defaultManager]findSearchSuggestionsWithPrefix:self.searchBar.text limit:@(numOfSearchSuggestions)];

    if (searchSuggestions.count) {
        // reload extension
        if ([self containsExtension:_searchSuggestionsExtension]) {
            _searchSuggestionsExtension.searchSuggestions = [[NSMutableArray alloc]initWithArray:searchSuggestions];
            [self reloadExtensions:@[_searchSuggestionsExtension] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        // add the extension and reload tableView
        else {
            _searchSuggestionsExtension = [[BFSearchSuggestionsTableViewCellExtension alloc]initWithTableViewController:self];
            _searchSuggestionsExtension.searchSuggestions = [[NSMutableArray alloc]initWithArray:searchSuggestions];
            [self addExtension:_searchSuggestionsExtension];
        }
    }
    else {
        // remove the extension
        if (!self.searchBar.text.length && [self containsExtension:_searchSuggestionsExtension]) {
            _searchSuggestionsExtension.searchSuggestions = [[NSMutableArray alloc]init];
            [self removeExtension:_searchSuggestionsExtension];
        }
    }
}

#pragma mark - Language changed notification

- (void)shopChangedAction {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self performSearchQueryRequest:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:true animated:true];
    return true;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:false animated:true];
    return true;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.searchText.length && searchText.length) {
        self.searchText = searchText;
        [self updateSearchSuggestionsExtension];
    }
    else {
        self.searchText = searchText;
        [self setupExtensions];
    }
}


#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataImage = nil;
    self.emptyDataTitle = BFLocalizedString(kTranslationNoSearchQueries, @"No previous search queries");
    self.emptyDataSubtitle = BFLocalizedString(kTranslationWhoSeeksFinds, @"Who seeks finds");
}


#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.searchBar becomeFirstResponder];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self.searchBar becomeFirstResponder];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // search bar
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont BFN_robotoRegularWithSize:13]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont BFN_robotoRegularWithSize:13]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{
                                                             NSFontAttributeName : [UIFont BFN_robotoMediumWithSize:14],
                                                             NSForegroundColorAttributeName : [UIColor BFN_pinkColor]
                                                             } forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:BFLocalizedString(kTranslationCancel, @"Cancel")];
}


#pragma mark - Search Query Requests

- (void)performSearchQueryRequest:(NSString *)searchQuery {
    if(searchQuery && searchQuery.length) {
        // save search query
        [[StorageManager defaultManager]addSearchQueryString:searchQuery];

        // products for search query
        BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc]init];
        [productInfo setSearchQuery:searchQuery];
        [productInfo setResultsTitle:searchQuery];
        self.segueParameters = @{segueParameterProductInfo : productInfo};
        [self performSegueWithIdentifier:productsSegueIdentifier sender:self];
    }
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // products controller
    if ([[segue identifier] isEqualToString:productsSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFProductsViewController class]]) {
            BFProductsViewController *productsController = (BFProductsViewController *)segue.destinationViewController;
            [self applySegueParameters:productsController];
        }
    }
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductsViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productsSegueIdentifier sender:self];
    }
}



@end
