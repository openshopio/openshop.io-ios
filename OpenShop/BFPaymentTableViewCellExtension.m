//
//  BFOrderPaymentTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 24.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFPaymentTableViewCellExtension.h"
#import "BFSelectableTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFPaymentViewController.h"
#import "BFOrderFormViewController.h"
#import "BFCartPayment.h"
#import "ShoppingCart.h"

/**
 * Payment item table view cell reuse identifier.
 */
static NSString *const paymentItemCellReuseIdentifier              = @"BFOrderPaymentTableViewCell";
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
static CGFloat const extensionHeaderViewHeight                     = 40.0;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 15.0;

@interface BFPaymentTableViewCellExtension ()

@end

@implementation BFPaymentTableViewCellExtension

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.paymentItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return UITableViewAutomaticDimension;
}

- (CGFloat)getEstimatedHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (void)willDisplayCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    BFCartPayment *payment = [self.paymentItems objectAtIndex:index];
    BFCartPayment *selectedPayment = [[ShoppingCart sharedCart] selectedPayment];
    
    if (selectedPayment.paymentID && [payment.paymentID isEqualToNumber:selectedPayment.paymentID]) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFCartPayment *payment = [self.paymentItems objectAtIndex:index];

    NSString *cellReuseIdentifier = paymentItemCellReuseIdentifier;
    
    BFSelectableTableViewCell *cell = (BFSelectableTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFSelectableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = payment.name;
    cell.subtitleLabel.text = payment.paymentDescription;
    cell.detailAccesoryLabel.text = payment.priceFormatted;

    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:extensionHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:extensionHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationPaymentMethod, @"Payment method") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFCartPayment *payment = [self.paymentItems objectAtIndex:index];
    if (self.didSelectPaymentBlock) {
        self.didSelectPaymentBlock(payment);
    }
    [self.tableViewController performSegueWithViewController:[BFOrderFormViewController class] params:nil];
}

@end
