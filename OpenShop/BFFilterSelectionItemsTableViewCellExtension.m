//
//  BFFilterSelectionItemsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFFilterSelectionItemsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "BFAppStructure.h"
#import "BFSelectionViewController.h"

/**
 * Filter selection item table view cell reuse identifier.
 */
static NSString *const filterSelectionItemCellReuseIdentifier        = @"BFFilterSelectionItemTableViewCellIdentifier";
/**
 * Filter selection item header view reuse identifier.
 */
static NSString *const filterSelectionItemHeaderViewReuseIdentifier  = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Filter selection item header view nib file name.
 */
static NSString *const filterSelectionItemHeaderViewNibName          = @"BFTableViewGroupedHeaderFooterView";
/**
 * Filter selection item table view cell height.
 */
static CGFloat const filterSelectionItemCellHeight                   = 46.0;
/**
 * Filter selection item header view height.
 */
static CGFloat const filterSelectionItemHeaderViewHeight             = 50.0;
/**
 * Filter selection item empty footer view height.
 */
static CGFloat const filterSelectionItemEmptyFooterViewHeight        = 15.0;
/**
 * Presenting segue selection items parameter.
 */
static NSString *const segueParameterItems                           = @"items";
/**
 * Presenting segue selected items parameter.
 */
static NSString *const segueParameterSelectedItems                   = @"selectedItems";
/**
 * Presenting segue filter type parameter.
 */
static NSString *const segueParameterFilterType                      = @"filterType";
/**
 * Presenting segue navigation item title parameter.
 */
static NSString *const segueParameterNavigationTitle                 = @"navigationTitle";



@interface BFFilterSelectionItemsTableViewCellExtension ()

/**
 * Filter selection items.
 */
@property (nonatomic, strong) NSArray *filterSelectionItems;
/**
 * Selected filter items (product variant colors).
 */
@property (nonatomic, strong, nullable) NSArray<BFProductVariantColor *> *selectedProductVariantColors;
/**
 * Selected filter items (product variant sizes).
 */
@property (nonatomic, strong, nullable) NSArray<BFProductVariantSize *> *selectedProductVariantSizes;
/**
 * Selected filter items (product brands).
 */
@property (nonatomic, strong, nullable) NSArray<BFProductBrand *> *selectedProductBrands;
/**
 * Filter items (product variant colors).
 */
@property (nonatomic, strong) NSArray<BFProductVariantColor *> *productVariantColors;
/**
 * Filter items (product variant sizes).
 */
@property (nonatomic, strong) NSArray<BFProductVariantSize *> *productVariantSizes;
/**
 * Filter items (product brands).
 */
@property (nonatomic, strong) NSArray<BFProductBrand *> *productBrands;

@end


@implementation BFFilterSelectionItemsTableViewCellExtension


#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:filterSelectionItemHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:filterSelectionItemHeaderViewReuseIdentifier];

    [self updateFilterSelectionItems];
}

- (void)updateFilterSelectionItems {
    // build filter items
    NSMutableArray *filterItems = [NSMutableArray new];
    if([self.productVariantSizes count]) {
        [filterItems addObject:@(BFNProductFilterTypeSelect)];
    }
    if([self.productVariantColors count]) {
        [filterItems addObject:@(BFNProductFilterTypeColor)];
    }
    self.filterSelectionItems = filterItems;
}

- (void)setFilterAttributes:(BFProductFilterAttributes *)filterAttributes {
    _filterAttributes = filterAttributes;
    if(_filterAttributes) {
        _selectedProductVariantColors = _filterAttributes.selectedProductVariantColors;
        _selectedProductVariantSizes = _filterAttributes.selectedProductVariantSizes;
        _selectedProductBrands = _filterAttributes.selectedProductBrands;
        
        _productVariantColors = _filterAttributes.productVariantColors;
        _productVariantSizes = _filterAttributes.productVariantSizes;
        _productBrands = _filterAttributes.productBrands;
    }
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.filterSelectionItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return filterSelectionItemCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    // table view cell
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:filterSelectionItemCellReuseIdentifier];
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filterSelectionItemCellReuseIdentifier];
    }
    
    BFNFilterType filterType = (BFNFilterType)[[self.filterSelectionItems objectAtIndex:index]integerValue];
    switch (filterType) {
        case BFNProductFilterTypeColor:
            [cell.headerlabel setText:BFLocalizedString(kTranslationFilterColor, @"Color")];
            [cell.subheaderLabel setText:[self formatSelectionText:(NSArray *)self.selectedProductVariantColors]];
            break;
        case BFNProductFilterTypeSelect:
            [cell.headerlabel setText:BFLocalizedString(kTranslationFilterSize, @"Size")];
            [cell.subheaderLabel setText:[self formatSelectionText:(NSArray *)self.selectedProductVariantSizes]];
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)formatSelectionText:(NSArray<id <BFNFiltering>> *)selectedItems {
    NSMutableString *formattedString = [[NSMutableString alloc]init];
    for (id<BFNFiltering> value in selectedItems) {
        if(![formattedString isEqualToString:@""]) {
            [formattedString appendFormat:@", "];
        }
        [formattedString appendFormat:@"%@", [value filterValue]];
    }
    return [formattedString isEqualToString:@""] ? BFLocalizedString(kTranslationAll, @"All") : formattedString;
}

#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:filterSelectionItemHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:filterSelectionItemHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationProperties, @"Properties") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return filterSelectionItemHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return filterSelectionItemEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFNFilterType filterType = (BFNFilterType)[[self.filterSelectionItems objectAtIndex:index]integerValue];

    NSDictionary *segueParams;
    switch (filterType) {
        case BFNProductFilterTypeColor:
            segueParams = @{segueParameterNavigationTitle : BFLocalizedString(kTranslationFilterColor, @"Color"),
                            segueParameterFilterType : @(filterType),
                            segueParameterItems : self.productVariantColors,
                            segueParameterSelectedItems : self.selectedProductVariantColors ?: @[],
                            };
            break;
        case BFNProductFilterTypeSelect:
            segueParams = @{segueParameterNavigationTitle : BFLocalizedString(kTranslationFilterSize, @"Size"),
                            segueParameterFilterType : @(filterType),
                            segueParameterItems : self.productVariantSizes,
                            segueParameterSelectedItems : self.selectedProductVariantSizes ?: @[],
                            };
            break;
        default:
            break;
    }

    [self.tableViewController performSegueWithViewController:[BFSelectionViewController class] params:segueParams];
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
