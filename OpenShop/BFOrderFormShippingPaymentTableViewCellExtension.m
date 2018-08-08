//
//  BFshippingAndPaymentTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 18.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFOrderFormShippingPaymentTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFCartPayment.h"
#import "BFCartDelivery.h"
#import "BFPaymentViewController.h"
#import "BFShippingViewController.h"
#import "ShoppingCart.h"

/**
 * shipping and payment item table view cell reuse identifier.
 */
static NSString *const shippingAndPaymentItemCellReuseIdentifier            = @"BFOrderFormDisclosureTableViewCell";
/**
 * Button footer view reuse identifier.
 */
static NSString *const buttonFooterViewReuseIdentifier                      = @"BFTableViewButtonHeaderFooterViewIdentifier";
/**
 * shipping and payment items header view reuse identifier.
 */
static NSString *const shippingAndPaymentItemsHeaderViewReuseIdentifier     = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * shipping and payment items header view nib file name.
 */
static NSString *const shippingAndPaymentItemsHeaderViewNibName             = @"BFTableViewGroupedHeaderFooterView";
/**
 * Button header view nib file name.
 */
static NSString *const buttonFooterViewNibName                              = @"BFTableViewButtonHeaderFooterView";
/**
 * shipping and payment item table view cell height.
 */
static CGFloat const shippingAndPaymentItemCellHeight                    = 42.0;
/**
 * shipping and payment items header view height.
 */
static CGFloat const shippingAndPaymentItemsHeaderViewHeight             = 50.0;
/**
 * shipping and payment items empty footer view height.
 */
static CGFloat const shippingAndPaymentItemsEmptyFooterViewHeight        = 15.0;

@interface BFOrderFormShippingPaymentTableViewCellExtension ()

/**
 * shipping and payment items data source.
 */
@property (nonatomic, strong) NSArray *shippingAndPaymentItems;

@end


@implementation BFOrderFormShippingPaymentTableViewCellExtension

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        [self refreshDataSource];
    }
    return self;
}

- (void)refreshDataSource {
    // shipping and payment items
    BFCartDelivery *delivery = [[ShoppingCart sharedCart] selectedDelivery];
    if (delivery) {
        self.shippingAndPaymentItems = @[@(BFShippingAndPaymentItemShipping), @(BFShippingAndPaymentItemPayment)];
    } else {
        self.shippingAndPaymentItems = @[@(BFShippingAndPaymentItemShipping)];
    }
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:shippingAndPaymentItemsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:shippingAndPaymentItemsHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.shippingAndPaymentItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return shippingAndPaymentItemCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:shippingAndPaymentItemCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shippingAndPaymentItemCellReuseIdentifier];
    }

    switch (index) {
        case BFShippingAndPaymentRowShipping: {
            cell.headerlabel.text = BFLocalizedString(kTranslationShipping, @"Shipping");
            BFCartDelivery *delivery = [[ShoppingCart sharedCart] selectedDelivery];
            cell.subheaderLabel.text = delivery.name;

            break;
        }
        case BFShippingAndPaymentRowPayment: {
            cell.headerlabel.text = BFLocalizedString(kTranslationPayment, @"Payment");
            BFCartPayment *payment = [[ShoppingCart sharedCart] selectedPayment];
            cell.subheaderLabel.text = payment.name;

            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:shippingAndPaymentItemsHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:shippingAndPaymentItemsHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationShippingAndPayment, @"Shipping and payment") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return shippingAndPaymentItemsHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return shippingAndPaymentItemsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    switch (index) {
            // shipping
        case BFShippingAndPaymentRowShipping:
            [self.tableViewController performSegueWithViewController:[BFShippingViewController class] params:nil];
            break;
            // payment
        case BFShippingAndPaymentRowPayment:
            [self.tableViewController performSegueWithViewController:[BFPaymentViewController class] params:nil];
            break;
        default:
            break;
    }
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}

@end
