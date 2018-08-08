//
//  BFOrderItemsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderItemsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIColor+BFColor.h"
#import "BFProductsTableViewCell.h"
#import "BFProductDetailViewController.h"
#import "BFTableViewHeaderFooterView.h"

/**
 *  Order items empty footer view height.
 */
static CGFloat const orderItemsEmptyFooterViewHeight         = 15.0;
/**
 * Order items table view cell height.
 */
static CGFloat const orderItemsCellHeight                    = 240.0;
/**
 * Order items table view cell reuse identifier.
 */
static NSString *const orderItemsCellReuseIdentifier         = @"BFOrderDetailItemsTableViewCellIdentifier";
/**
 * Order items header view reuse identifier.
 */
static NSString *const orderItemsHeaderViewReuseIdentifier   = @"BFOrderDetailsHeaderViewIdentifier";
/**
 * Order items header view nib file name.
 */
static NSString *const orderItemsHeaderViewNibName           = @"BFTableViewGroupedHeaderFooterView";
/**
 * Order items header view height.
 */
static CGFloat const orderDetailsHeaderViewHeight            = 50.0;
/**
 * Presenting segue product data model parameter.
 */
static NSString *const segueParameterProduct                 = @"product";



@interface BFOrderItemsTableViewCellExtension ()


@end


@implementation BFOrderItemsTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {

    }
    return self;
}

- (void)didLoad {
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return ([self.orderItems count] > 0) ? 1 : 0;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return orderItemsCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFProductsTableViewCell *cell = (BFProductsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:orderItemsCellReuseIdentifier];
    if(!cell) {
        cell = [[BFProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderItemsCellReuseIdentifier];
    }

    // order items (products)
    [cell setData:self.orderItems];
    
    __weak __typeof__(self) weakSelf = self;
    cell.productSelectionBlock = ^(BFProduct *product) {
        [weakSelf.tableViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{segueParameterProduct : product}];
    };
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    if([self.orderItems count] > 0) {
        BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:orderItemsHeaderViewReuseIdentifier];
        if(!textHeaderView) {
            textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:orderItemsHeaderViewReuseIdentifier];
        }
        [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationOrderItemsList, @"Items list")uppercaseString]];
        return textHeaderView;
    }
    return nil;
}

- (CGFloat)getHeaderHeight {
    return ([self.orderItems count] > 0) ? orderDetailsHeaderViewHeight : 0.0;
}

- (CGFloat)getFooterHeight {
    return orderItemsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}


@end
