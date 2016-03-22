//
//  BFSearchSuggestionsTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 16.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFSearchSuggestionsTableViewCellExtension.h"
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
static CGFloat const searchSuggestionsCellHeight                    = 42.0f;
/**
 * Search queries header view height.
 */
static CGFloat const searchSuggestionsHeaderViewHeight            = 50.0f;
/**
 * Search queries empty footer view height.
 */
static CGFloat const searchSuggestionsEmptyFooterViewHeight       = 15.0f;



@interface BFSearchSuggestionsTableViewCellExtension ()


@end


@implementation BFSearchSuggestionsTableViewCellExtension

@dynamic tableViewController;

#pragma mark - Initialization

- (void)didLoad {
    // register header view
    [self.tableView registerNib:[UINib nibWithNibName:searchQueriesHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:searchQueriesHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.searchSuggestions count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return searchSuggestionsCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:searchQueryCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchQueryCellReuseIdentifier];
    }
    
    // search suggestion
    BFSearchSuggestion *searchSuggestion = [self.searchSuggestions objectAtIndex:index];
    
    NSString *categoryPrefix = [NSString stringWithFormat:@"%@ : ", BFLocalizedString(kTranslationCategory, @"Category") ];
    NSString *suggestion = searchSuggestion.suggestion;
    NSMutableAttributedString *attributedSuggestion = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", categoryPrefix, suggestion]];
    [attributedSuggestion addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor grayColor]
                                 range:NSMakeRange(0, categoryPrefix.length)];
    // search suggestion text
    cell.headerlabel.attributedText = attributedSuggestion;
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:searchQueriesHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:searchQueriesHeaderViewReuseIdentifier];
    }
    
    [textHeaderView.headerlabel setText:BFLocalizedString(kTranslationSearchSuggestions, @"Search suggestions")];
    return textHeaderView;
}

- (CGFloat)getHeaderEstimatedHeight {
    return searchSuggestionsHeaderViewHeight;
}

- (CGFloat)getHeaderHeight {
    return searchSuggestionsHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return searchSuggestionsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // search query
    BFSearchSuggestion *searchSuggestion = [self.searchSuggestions objectAtIndex:index];
    
    // products for search query
    [self.tableViewController performSearchQueryRequest:searchSuggestion.suggestion];
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end

