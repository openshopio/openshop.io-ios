//
//  BFOrderDetailsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderDetailsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "BFAppPreferences.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFOrderDetailViewController.h"
#import "BFOrderShipping.h"

/**
 * Order detail item table view cell reuse identifier.
 */
static NSString *const orderDetailItemReuseIdentifier        = @"BFOrderDetailItemTableViewCellIdentifier";
/**
 * Order details header view reuse identifier.
 */
static NSString *const orderDetailsHeaderViewReuseIdentifier = @"BFOrderDetailsHeaderViewIdentifier";
/**
 * Order details header view nib file name.
 */
static NSString *const orderDetailsHeaderViewNibName         = @"BFTableViewGroupedHeaderFooterView";
/**
 * Order details header view height.
 */
static CGFloat const orderDetailsHeaderViewHeight            = 50.0;
/**
 * Order details empty footer view height.
 */
static CGFloat const orderDetailsEmptyFooterViewHeight       = 10.0;
/**
 * Order detail item table view cell height.
 */
static CGFloat const orderDetailItemHeight                   = 60.0;

/**
 * Order details item types.
 */
typedef NS_ENUM(NSInteger, BFOrderDetailsItem) {
    BFOrderDetailsItemID = 0,
    BFOrderDetailsItemClientName,
    BFOrderDetailsItemDate,
    BFOrderDetailsItemTotalPrice,
    BFOrderDetailsItemShippingName,
    BFOrderDetailsItemShippingPrice
};


@interface BFOrderDetailsTableViewCellExtension ()

/**
 * Order detail items data source.
 */
@property (nonatomic, strong) NSArray *orderDetailItems;

@end


@implementation BFOrderDetailsTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)viewController {
    self = [super initWithTableViewController:viewController];
    if (self) {
        self.orderDetailItems = @[];
    }
    return self;
}

- (void)didLoad {
    // register header view
    [self.tableView registerNib:[UINib nibWithNibName:orderDetailsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:orderDetailsHeaderViewReuseIdentifier];
    // data source
    self.orderDetailItems = @[@(BFOrderDetailsItemID),@(BFOrderDetailsItemClientName),@(BFOrderDetailsItemDate),@(BFOrderDetailsItemTotalPrice),@(BFOrderDetailsItemShippingName),@(BFOrderDetailsItemShippingPrice)];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return self.finishedLoading ? [self.orderDetailItems count] : 0;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return orderDetailItemHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:orderDetailItemReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc]init];
    }
    // order item
    BFOrderDetailsItem orderDetailsItem = (BFOrderDetailsItem)[[self.orderDetailItems objectAtIndex:index]integerValue];

    switch (orderDetailsItem) {
        case BFOrderDetailsItemID:
            // item name
            cell.headerlabel.text = BFLocalizedString(kTranslationOrderID, @"Order ID");
            // item value
            cell.subheaderLabel.text = self.order.orderRemoteID ? [NSString stringWithFormat:@"%@", self.order.orderRemoteID] : @"";
            break;
        case BFOrderDetailsItemClientName:
            // item name
            cell.headerlabel.text = BFLocalizedString(kTranslationOrderClientName, @"Name");
            // item value
            cell.subheaderLabel.text = self.order.clientName ?: @"";
            break;
        case BFOrderDetailsItemDate:{
            // item name
            cell.headerlabel.text = BFLocalizedString(kTranslationOrderDateCreated, @"Date created");
            // item value
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterNoStyle;
            cell.subheaderLabel.text = self.order.date ? (NSString *)[dateFormatter stringFromDate:(NSDate *)self.order.date] : @"";
            break;
    }
        case BFOrderDetailsItemTotalPrice:
            // item name
            cell.headerlabel.text = BFLocalizedString(kTranslationOrderTotalPrice, @"Total");
            // item value
            cell.subheaderLabel.text = self.order.totalPriceFormatted ? [NSString stringWithFormat:@"%@", self.order.totalPriceFormatted] : @"";
            break;
        case BFOrderDetailsItemShippingName:
            // item name
            cell.headerlabel.text = BFLocalizedString(kTranslationOrderShippingName, @"Shipping");
            // item value
            cell.subheaderLabel.text = self.order.shipping && self.order.shipping.name ? self.order.shipping.name : @"";
            break;
        case BFOrderDetailsItemShippingPrice:
            // item name
            cell.headerlabel.text = BFLocalizedString(kTranslationOrderTransportPrice, @"Delivery price");
            // item value
            cell.subheaderLabel.text = self.order.shipping && self.order.shipping.priceFormatted ? self.order.shipping.priceFormatted : @"";
            break;
        default:
            break;
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    if(self.finishedLoading) {
        BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:orderDetailsHeaderViewReuseIdentifier];
        if(!textHeaderView) {
            textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:orderDetailsHeaderViewReuseIdentifier];
        }
        [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationOrderDetail, @"Order detail")uppercaseString]];
        return textHeaderView;
    }
    return nil;
}

- (CGFloat)getHeaderHeight {
    return self.finishedLoading ? orderDetailsHeaderViewHeight : 0.0;
}

- (CGFloat)getFooterHeight {
    return orderDetailsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}




@end
