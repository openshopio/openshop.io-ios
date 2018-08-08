//
//  BFOrderSummaryAddressTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 24.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFOrderSummaryAddressTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "ShoppingCart.h"

/**
 * Address item table view cell reuse identifier.
 */
static NSString *const addressItemCellReuseIdentifier              = @"BFOrderSummaryAddressTableViewCell";
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
static CGFloat const extensionEmptyFooterViewHeight                = 35.0;

@interface BFOrderSummaryAddressTableViewCellExtension ()

/**
 * Shipping items data source.
 */
@property (nonatomic, strong) NSArray *addressItems;

@end

@implementation BFOrderSummaryAddressTableViewCellExtension

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        // shipping and payment items
        self.addressItems = @[@(BFOrderSummaryAddressRowNamePhone), @(BFOrderSummaryAddressRowStreetHouseEmail), @(BFOrderSummaryAddressRowZIPCity)];
    }
    return self;
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.addressItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    NSString *cellReuseIdentifier = addressItemCellReuseIdentifier;
    
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    switch (index) {
        case BFOrderSummaryAddressRowNamePhone:
            cell.headerlabel.text = [[ShoppingCart sharedCart] name];
            cell.subheaderLabel.text = [[ShoppingCart sharedCart] phone];
            break;
            
        case BFOrderSummaryAddressRowStreetHouseEmail:
            cell.headerlabel.text = [NSString stringWithFormat:@"%@ %@", [[ShoppingCart sharedCart] addressStreet], [[ShoppingCart sharedCart] addressHouseNumber]];
            cell.subheaderLabel.text = [[ShoppingCart sharedCart] email];
            break;

        case BFOrderSummaryAddressRowZIPCity:
            cell.headerlabel.text = [[ShoppingCart sharedCart] addressPostalCode];
            cell.subheaderLabel.text = [[ShoppingCart sharedCart] addressCity];
            break;

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
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationAddress, @"Address") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

@end


