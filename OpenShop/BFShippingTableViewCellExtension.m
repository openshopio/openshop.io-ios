//
//  BFOrderShippingTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFShippingTableViewCellExtension.h"
#import "BFSelectableTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFCartDelivery.h"
#import "BFShippingViewController.h"
#import "BFPaymentViewController.h"
#import "ShoppingCart.h"

/**
 * Shipping item table view cell reuse identifier.
 */
static NSString *const shippingItemCellReuseIdentifier              = @"BFOrderShippingTableViewCell";
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
 * Extension table view cell height.
 */
static CGFloat const extensionCellHeight                           = 82.0;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 50.0;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 15.0;

@interface BFShippingTableViewCellExtension ()

@end

@implementation BFShippingTableViewCellExtension

#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:buttonFooterViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:buttonFooterViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.shippingItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return UITableViewAutomaticDimension;
}

- (CGFloat)getEstimatedHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.shippingItems objectAtIndex:index];

    NSString *cellReuseIdentifier = shippingItemCellReuseIdentifier;
    BFSelectableTableViewCell *cell = (BFSelectableTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFSelectableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = delivery.name;
    cell.subtitleLabel.text = delivery.deliveryDescription;
    cell.detailAccesoryLabel.text = delivery.priceFormatted;
    
    return cell;
}

#pragma mark - UITableViewDelegate

/**
 * It was necessary to implement this method to resolve the
 * issue when the custom UITableViewCell subclass
 * lost a selection on appear.
 */
- (void)willDisplayCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.shippingItems objectAtIndex:index];
    BFCartDelivery *selectedDelivery = [[ShoppingCart sharedCart] selectedDelivery];

    if (selectedDelivery.deliveryID && [delivery.deliveryID isEqualToNumber:selectedDelivery.deliveryID]) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:extensionHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:extensionHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationShipping, @"Shipping") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.shippingItems objectAtIndex:index];
    if (self.didSelectDeliveryBlock) {
        self.didSelectDeliveryBlock(delivery);
    }
    [self.tableViewController performSegueWithViewController:[BFPaymentViewController class] params:nil];
}

@end
