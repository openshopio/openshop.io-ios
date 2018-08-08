//
//  BFOrderSummaryPaymentShippingTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 24.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFOrderSummaryShippingPaymentTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFCartDelivery.h"
#import "BFCartPayment.h"
#import "StorageManager.h"
#import "ShoppingCart.h"

/**
 * Order summary product item table view cell reuse identifier.
 */
static NSString *const shippingPaymentItemCellReuseIdentifier      = @"BFOrderSummaryShippingPaymentTableViewCell";
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
static CGFloat const extensionCellHeight                           = 37.0;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 50.0;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 15.0;

@interface BFOrderSummaryShippingPaymentTableViewCellExtension ()

/**
 * Shipping items data source.
 */
@property (nonatomic, strong) NSArray *shippingPaymentItems;

@end

@implementation BFOrderSummaryShippingPaymentTableViewCellExtension

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        // shipping and payment items
        self.shippingPaymentItems = @[@(BFShippingAndPaymentItemShipping), @(BFShippingAndPaymentItemPayment)];
    }
    return self;
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.shippingPaymentItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    NSString *cellReuseIdentifier = shippingPaymentItemCellReuseIdentifier;
    
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    switch (index) {
        case BFShippingAndPaymentRowShipping: {
            cell.headerlabel.text = BFLocalizedString(kTranslationShipping, @"Shipping");
            cell.subheaderLabel.text = [[[ShoppingCart sharedCart] selectedDelivery] name];
            
            break;
        }
        case BFShippingAndPaymentRowPayment: {
            cell.headerlabel.text = BFLocalizedString(kTranslationPayment, @"Payment");
            cell.subheaderLabel.text = [[[ShoppingCart sharedCart] selectedPayment] name];
            
            break;
        }
        default:
            break;
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
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationShippingAndPayment, @"Shipping and payment") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

@end


