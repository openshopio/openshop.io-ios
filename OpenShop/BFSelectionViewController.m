//
//  BFSelectionViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSelectionViewController.h"
#import "UIColor+BFColor.h"
#import "UIFont+BFFont.h"
#import "BFSeparatorTableViewCell.h"



@interface BFSelectionViewController ()

/**
 * Data source items indexes. This property is constructed from the items.
 */
@property(nonatomic, strong) NSArray *letters;
/**
 * Data source items currently displayed with respect to given filters. This property
 * is based on items.
 */
@property(nonatomic, strong) NSArray *displayItems;
/**
 * Data source items structured into sections to be displayed in a list with fast
 * navigation. This property is constructed from the displayItems.
 */
@property(nonatomic, strong) NSDictionary *structuredItems;
/**
 * Selected indexes of the items from the data source.
 */
@property(nonatomic, strong) NSMutableIndexSet *selectedIndexes;
/**
 * Navigation bar button that deselects all items.
 */
@property(nonatomic, strong) UIBarButtonItem *clearButton;
/**
 * Checkmark view for each item saved with key representing its position in a list.
 */
@property(nonatomic, strong) NSMutableDictionary *checkmarks;
/**
 * Filtering interface with search bar.
 */
@property (nonatomic, strong) UISearchBar *searchBar;

@end


/**
 * Table view row height.
 */
static NSInteger const checkmarkCellRowHeight              = 44.0;
/**
 * Table view row separator left margin.
 */
static NSInteger const checkmarkCellRowSeparatorLeftMargin = 30;
/**
 * Table view row with checkmark reuse identifier.
 */
static NSString *const checkmarkCellReuseIdentifier        = @"BFSelectionTableViewCellIdentifier";
/**
 * Blank section placeholder identifier to extend spaces between letters representing
 * valid table view sections.
 */
static NSString *const sectionIndexTitleSpacing            = @"";
/**
 * Search view section index used in fast navigation.
 */
static NSInteger const searchViewSectionIndex              = -1;
/**
 * Minimum number of rows required to display fast navigation with alphabetical indexes.
 */
static NSInteger const minRowsToDisplaySectionIndexes      = 8;


@implementation BFSelectionViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        // title view
        _navigationTitle = BFLocalizedString(kTranslationFilter, @"Filter");
        // flags
        _multiSelection = false;
        _searchingEnabled = false;
        _animateSelection = true;
        _fastNavigation = true;
        _sortAlphabetically = true;
        // data source
        _items = @[];
        _selectedIndexes = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSet]];
        _checkmarks = [[NSMutableDictionary alloc]init];
        _displayItems = _items;
        _structuredItems = [self structuredItemsForItems:_displayItems];
        // colors
        _textColor = [UIColor blackColor];
        _navigationColor = [UIColor BFN_pinkColor];
    }
    return self;
}


#pragma mark - Properties Setters / Getters

-(void)setMultiSelection:(BOOL)newMultiSelection {
    _multiSelection = newMultiSelection;
    // switched from multi selection to a single selection requires selected indexes update
    if(!newMultiSelection && _selectedIndexes.count > 1) {
        // deselect all items except the last one
        NSInteger lastIndex = [_selectedIndexes lastIndex];
        [_selectedIndexes removeIndex:lastIndex];
        [self deselectRowsWithItemIndexes:_selectedIndexes];
        // new selected indexes
        _selectedIndexes = [[NSMutableIndexSet alloc]initWithIndex:lastIndex];
        // refresh table view
        [self.tableView reloadData];
    }
}

- (void)setSortAlphabetically:(BOOL)newSortAlphabetically {
    _sortAlphabetically = newSortAlphabetically;
    // alphabetical order may change the data source order
    [self setDisplayItems:_items];
}

- (void)setDisplayItems:(NSArray<id<BFNSelection>> *)newDisplayItems {
    _displayItems = _sortAlphabetically ? [newDisplayItems sortedArrayUsingSelector:@selector(compare:)] : newDisplayItems;
    // structure items into sections to be displayed in a table view
    _structuredItems = [self structuredItemsForItems:_displayItems];
    [self.tableView reloadData];
}

- (void)setItems:(NSArray<id<BFNSelection>> *)items {
    _items = items;
    [self setDisplayItems:_items];
    [self updateSelectedIndexes];
}

- (void)setSelectedItems:(NSArray<id<BFNSelection>> *)selectedItems {
    _selectedItems = selectedItems;
    [self updateSelectedIndexes];
}

- (void)updateSelectedIndexes {
    NSIndexSet *selectedIndexes = [self indexSetForSelectedItems:_selectedItems inDataSource:_items];
    _selectedIndexes = [[NSMutableIndexSet alloc]initWithIndexSet:selectedIndexes != nil ? selectedIndexes : [NSIndexSet indexSet]];
}


- (UISearchBar *)searchBar {
    if (!_searchBar) {
        // init
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
        // style
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.placeholder = BFLocalizedString(kTranslationWhoSeeksFinds, @"Who seeks finds");
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeyDone;
        // appearance
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont BFN_robotoRegularWithSize:13]];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont BFN_robotoRegularWithSize:13]}];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont BFN_robotoMediumWithSize:14],NSForegroundColorAttributeName : [UIColor BFN_pinkColor]} forState:UIControlStateNormal];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:BFLocalizedString(kTranslationCancel, @"Cancel")];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitlePositionAdjustment:UIOffsetMake(0, 2.0f) forBarMetrics:UIBarMetricsDefault];
    }
    return _searchBar;
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // table view appearance and style
    [self.class customizeAppearance];
    self.tableView.sectionIndexMinimumDisplayRowCount = minRowsToDisplaySectionIndexes;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, CGFLOAT_MIN)];
    
    // title view
    self.navigationItem.title = [_navigationTitle uppercaseString];
    
    // empty data set
    [self customizeEmptyDataSet];
    
    // add search bar
    if(_searchingEnabled) {
        self.tableView.tableHeaderView = self.searchBar;
    }
    else {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, CGFLOAT_MIN)];
    }
    // clear all navigation bar button setup
    _clearButton = [[UIBarButtonItem alloc] initWithTitle:BFLocalizedString(kTranslationClearSelection, @"Clear selection") style:UIBarButtonItemStylePlain target:self action:@selector(clearSelection)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // navigation bar update
    [self updateNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // valid delegate
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectItems:fromItems:)]) {
        // report selection changes
        [self.delegate selectionController:self didSelectItems:[_items objectsAtIndexes:_selectedIndexes] fromItems:_items];
    }
    // valid block callback
    if(self.selectedItemsCallback) {
        // report selection changes
        self.selectedItemsCallback([_items objectsAtIndexes:_selectedIndexes], _items);
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchBar.text isEqualToString:@""]) {
        // reset search query
        [self setDisplayItems:_items];
    }
    else {
        // search with query (case insensitive, ignore accents)
        if ([_items count]) {
            NSPredicate *predicate = [[[_items firstObject] class] predicateWithSearchQuery:searchBar.text];
            [self setDisplayItems:[_items filteredArrayUsingPredicate:predicate]];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.tableView reloadSectionIndexTitles];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.tableView reloadSectionIndexTitles];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _letters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_structuredItems objectForKey:[_letters objectAtIndex:section]]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return checkmarkCellRowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BFSeparatorTableViewCell *cell = (BFSeparatorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:checkmarkCellReuseIdentifier];
    if(!cell) {
        cell = [[BFSeparatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkmarkCellReuseIdentifier];
    }
    
    NSArray<id<BFNSelection>> *letterArray = [_structuredItems objectForKey:[_letters objectAtIndex:indexPath.section]];
    // item text label
    cell.headerlabel.font = [UIFont BFN_robotoRegularWithSize:15.0];
    cell.headerlabel.textColor = _textColor;
    cell.headerlabel.text = [[letterArray objectAtIndex:indexPath.row]displayName];
    
    // top separator line
    cell.topSeparatorLine.hidden = true;
    if([indexPath compare:self.indexPathForFirstRow] == NSOrderedSame && !_searchingEnabled) {
        cell.topSeparatorLine.hidden = false;
    }
    // bottom separator line
    if([indexPath compare:self.indexPathForLastRow] == NSOrderedSame) {
        [cell.bottomSeparatorLine setLeftMargin:0.0];
    }
    else {
        [cell.bottomSeparatorLine setLeftMargin:checkmarkCellRowSeparatorLeftMargin];
    }
    
    // checkmark view
    NSUInteger itemIndex = [_items indexOfObject:[self selectedItemAtIndexPath:indexPath]];
    if(itemIndex != NSNotFound && [_selectedIndexes containsIndex:itemIndex]) {
        [cell.checkmark setSelected:true withAnimation:false];
    }
    else {
        [cell.checkmark setSelected:false withAnimation:false];
    }
    // register callback for value change
    [cell.checkmark addTarget:self action:@selector(checkmarkSelected:) forControlEvents:UIControlEventValueChanged];
    [_checkmarks setObject:(BFNCheckmarkView *)cell.checkmark forKey:[self checkmarkKeyForIndexPath:indexPath]];
    
    return cell;
}

- (IBAction)checkmarkSelected:(id)sender {
    BFNCheckmarkView *checkmark = (BFNCheckmarkView *)sender;
    if(checkmark) {
        id<BFNSelection> item = [self selectedItemForCheckmark:checkmark];
        // selected data source item index
        NSUInteger itemIndex = [_items indexOfObject:item];
        if(itemIndex != NSNotFound) {
            if(!checkmark.isSelected) {
                // deselected item
                [_selectedIndexes removeIndex:itemIndex];
            }
            else {
                // single selection
                if (!_multiSelection) {
                    // deselect all selected items
                    [self deselectRowsWithItemIndexes:_selectedIndexes];
                    [_selectedIndexes removeAllIndexes];
                }
                // select item
                [_selectedIndexes addIndex:itemIndex];
            }
        }
        [self updateNavigationBar];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect row
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    // selected row checkmark view
    BFNCheckmarkView *selectedRowCheckmark = [_checkmarks objectForKey:[self checkmarkKeyForIndexPath:indexPath]];
    // selected data source item index
    NSUInteger itemIndex = [_items indexOfObject:[self selectedItemAtIndexPath:indexPath]];
    
    if(selectedRowCheckmark) {
        if (itemIndex != NSNotFound) {
            // item deselected
            if([_selectedIndexes containsIndex:itemIndex]) {
                // deselect item
                [_selectedIndexes removeIndex:itemIndex];
                [selectedRowCheckmark setSelected:false withAnimation:_animateSelection];
            }
            // item selected
            else {
                // single selection
                if (!_multiSelection) {
                    // deselect all selected items
                    [self deselectRowsWithItemIndexes:_selectedIndexes];
                    [_selectedIndexes removeAllIndexes];
                }
                // select item
                [_selectedIndexes addIndex:itemIndex];
                [selectedRowCheckmark setSelected:true withAnimation:_animateSelection];
            }
        }
        // update navigation bar clear button
        [self updateNavigationBar];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    // no fast navigation
    if(!_fastNavigation) {
        return nil;
    }
    
    NSMutableArray *lettersWithBlank = [[NSMutableArray alloc]init];
    // number of section index titles
    NSInteger numOfLetters = _searchingEnabled ? _letters.count+1 : _letters.count;
    // total number of symbols for each section index title
    NSInteger totalSymbols = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles].count / numOfLetters;
    // reduce number of symbols when searching
    totalSymbols = !self.isSearching ? totalSymbols : totalSymbols/2;
    // format section index titles along with placeholder symbols
    for (int i = 0; i < numOfLetters; i++) {
        if(_searchingEnabled) {
            [lettersWithBlank addObject:i == 0 ? UITableViewIndexSearch : [_letters objectAtIndex:i-1]];
        }
        else {
            [lettersWithBlank addObject:[_letters objectAtIndex:i]];
        }
        // placeholder symbols
        for(int j = 1; j < totalSymbols; j++) {
            [lettersWithBlank addObject:sectionIndexTitleSpacing];
        }
    }
    
    return lettersWithBlank;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // number of section index titles
    NSInteger numOfLetters = _searchingEnabled ? _letters.count+1 : _letters.count;
    // total number of symbols for each section index title
    NSInteger totalSymbols = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles].count / numOfLetters;
    
    if(_searchingEnabled) {
        // search view section index selected
        if(index < totalSymbols) {
            [tableView scrollRectToVisible:self.tableView.tableHeaderView.frame animated:false];
            return searchViewSectionIndex;
        }
        // subtract search view section index
        index -= totalSymbols;
    }
    // calculate correct section index
    return index/totalSymbols;
}


#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataImage = [UIImage imageNamed:@"EmptyBannersPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationFilterNoFilters, @"No filters");
    self.emptyDataSubtitle = BFLocalizedString(kTranslationFilterUpdateFilter, @"Update filter");
}


#pragma mark - DZNEmptyDataSetSource

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return true;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    // not searching
    if(![self.searchBar isFirstResponder]) {
        // animate scroll up to prevent keyboard removal while scrolling
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView scrollRectToVisible:self.tableView.tableHeaderView.frame animated:false];
        } completion:^(BOOL finished){
            [self.searchBar becomeFirstResponder];
        }];
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // update basic filter - SelectionViewController must have been initialised with empty @items
    if ([self.searchBar.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    // update search query
    else if(![self.searchBar isFirstResponder]) {
        // animate scroll up to prevent keyboard removal while scrolling
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView scrollRectToVisible:self.tableView.tableHeaderView.frame animated:false];
        } completion:^(BOOL finished){
            [self.searchBar becomeFirstResponder];
        }];
    }
}


#pragma mark - TableView Helpers

- (BOOL)isSearching {
    return [self.searchBar isFirstResponder];
}

- (void)clearSelection {
    // something selected
    if(_selectedIndexes && _selectedIndexes.count) {
        // deselect all items
        [self deselectRowsWithItemIndexes:_selectedIndexes];
        [_selectedIndexes removeAllIndexes];
        [self updateNavigationBar];
    }
    // reset search query
    if(![self.searchBar.text isEqualToString:@""]) {
        [self.searchBar setText:@""];
        [self searchBar:self.searchBar textDidChange:@""];
    }
    if([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)deselectRowsWithItemIndexes:(NSIndexSet *)indexes {
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        id<BFNSelection> item = [self.items objectAtIndex:idx];
        if(item) {
            NSString *letter = [item sectionIndexTitle];
            if(letter) {
                // item section in table view
                NSUInteger itemSection = [self.letters indexOfObject:letter];
                if(itemSection != NSNotFound) {
                    NSArray *letterArray = [self.structuredItems objectForKey:letter];
                    if(letterArray) {
                        // item row in table view
                        NSUInteger itemRow = [letterArray indexOfObject:item];
                        if(itemRow != NSNotFound) {
                            // deselect item
                            BFNCheckmarkView *selectedRowCheckmark = [self.checkmarks objectForKey:[self checkmarkKeyForIndexPath:[NSIndexPath indexPathForRow:itemRow inSection:itemSection]]];
                            if(selectedRowCheckmark) {
                                [selectedRowCheckmark setSelected:false withAnimation:self.animateSelection];
                            }
                        }
                    }
                }
            }
        }
    }];
}

- (NSString *)checkmarkKeyForIndexPath:(NSIndexPath*)indexPath {
    // formatted key "section-row"
    return [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
}

- (NSIndexPath *)indexPathForCheckmarkKey:(NSString *)key {
    NSArray *keyPaths = [key componentsSeparatedByString:@"-"];
    if(keyPaths.count == 2) {
        return [NSIndexPath indexPathForRow:[[keyPaths objectAtIndex:1]integerValue] inSection:[[keyPaths objectAtIndex:0]integerValue]];
    }
    return nil;
}

- (id<BFNSelection>)selectedItemAtIndexPath:(NSIndexPath*)indexPath {
    // data source item at index path
    return [[_structuredItems objectForKey:[_letters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}

- (id<BFNSelection>)selectedItemForCheckmark:(BFNCheckmarkView*)checkmark {
    NSArray *keys = [_checkmarks allKeysForObject:checkmark];
    if(keys && keys.count) {
        // data source item at index path
        NSIndexPath *indexPath = [self indexPathForCheckmarkKey:[keys firstObject]];
        return [self selectedItemAtIndexPath:indexPath];
    }

    return nil;
}

- (NSIndexPath*)indexPathForFirstRow {
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath*)indexPathForLastRow {
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}


#pragma mark - Helpers

- (NSIndexSet *)indexSetForSelectedItems:(NSArray<id<BFNSelection>> *)selectedItems inDataSource:(NSArray<id<BFNSelection>> *)dataSource {
    // indexes of selected items in data source
    return [dataSource indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [selectedItems containsObject:obj];
    }];
}

- (void)updateNavigationBar {
    // show clear button when something selected
    self.navigationItem.rightBarButtonItem = _selectedIndexes.count ? _clearButton : nil;
}

- (NSDictionary *)structuredItemsForItems:(NSArray<id<BFNSelection>> *)items {
    NSMutableDictionary *structuredItems = [[NSMutableDictionary alloc]init];
    NSMutableArray *letters = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < items.count; i++) {
        id<BFNSelection> item = [items objectAtIndex:i];
        if(item) {
            // section index title
            NSString *letter = [item sectionIndexTitle];
            if(letter) {
                if(![letters containsObject:letter]) {
                    [letters addObject:letter];
                }
            
                // structure items into sections
                NSMutableArray *letterArray = [structuredItems objectForKey:letter];
                if(letterArray) {
                    [letterArray addObject:item];
                }
                else {
                    letterArray = [[NSMutableArray alloc]initWithObjects:item, nil];
                    [structuredItems setObject:letterArray forKey:letter];
                }
            }
        }
    }
    // sort section indexes
    _letters = _sortAlphabetically ? [letters sortedArrayUsingSelector:@selector(compare:)] : letters;
    return structuredItems;
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // no separator
    [UITableView appearanceWhenContainedIn:self, nil].separatorColor = [UIColor clearColor];
    // section index
    [UITableView appearanceWhenContainedIn:self.class, nil].sectionIndexColor = [UIColor BFN_pinkColor];
    [UITableView appearanceWhenContainedIn:self.class, nil].sectionIndexBackgroundColor = [UIColor clearColor];
    [UITableView appearanceWhenContainedIn:self.class, nil].sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    [UITableView appearanceWhenContainedIn:self.class, nil].separatorStyle = UITableViewCellSeparatorStyleNone;
}



@end
