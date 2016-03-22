//
//  BFOrderSummaryProductsTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 24.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFOrderSummaryProductsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFCartProductItem.h"
#import "BFProductVariant.h"
#import "ShoppingCart.h"

/**
 * Order summary product item table view cell reuse identifier.
 */
static NSString *const productItemCellReuseIdentifier              = @"BFOrderSummaryPriceTableViewCell";
/**
 * Order summary totla item table view cell reuse identifier.
 */
static NSString *const totalItemCellReuseIdentifier              = @"BFOrderSummaryTotalTableViewCell";
/**
 * Button footer view reuse identifier.
 */
static NSString *const buttonFooterViewReuseIdentifier             = @"BFTableViewButtonHeaderFooterViewIdentifier";
/**
 * Extension header view reuse identifier.
 */
static NSString *const extensionHeaderViewReuseIdentifier          = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Extension header view nib file name.
 */
static NSString *const extensionHeaderViewNibName                  = @"BFTableViewGroupedHeaderFooterView";
/**
 * Button header view nib file name.
 */
static NSString *const buttonFooterViewNibName                     = @"BFTableViewButtonHeaderFooterView";
/**
 * Extension table view product cell height.
 */
static CGFloat const extensionProductCellHeight                    = 37.0f;
/**
 * Extension table view total price cell height.
 */
static CGFloat const extensionTotalPriceCellHeight                 = 42.0f;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 50.0f;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 15.0f;

@interface BFOrderSummaryProductsTableViewCellExtension ()

/**
 * Shipping items data source.
 */
@property (nonatomic, strong) NSMutableArray *productItems;

@end

@implementation BFOrderSummaryProductsTableViewCellExtension

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        [self setupItems];
    }
    return self;
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

- (void)setupItems {
    // product items
    _productItems = [[NSMutableArray alloc] initWithArray:[[ShoppingCart sharedCart] products]];
    [_productItems addObject:@(BFOrderSummaryItemTotal)];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.productItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    if (index < self.productItems.count-1) {
        return extensionProductCellHeight;
    }
    else {
        return extensionTotalPriceCellHeight;
    }
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    NSString *cellReuseIdentifier;
    BFCartProductItem *product;
    BFTableViewCell *cell;
    
    if (index < self.productItems.count-1) {
        cellReuseIdentifier = productItemCellReuseIdentifier;
        product = self.productItems[index];
        cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        
        if(!cell) {
            cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        }
        
        cell.headerlabel.text = product.productVariant.name;
        cell.subheaderLabel.text = product.totalPriceFormatted;
    }
    else {
        cellReuseIdentifier = totalItemCellReuseIdentifier;
        cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        
        if(!cell) {
            cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        }
        
        cell.headerlabel.text = BFLocalizedString(kTranslationTotal, @"Total");
        cell.subheaderLabel.text = [[ShoppingCart sharedCart] totalPriceFormatted];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:extensionHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:extensionHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationProductsList, @"Products") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

@end

