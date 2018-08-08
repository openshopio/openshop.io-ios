//
//  BFCartDiscountsTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 30.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFCartDiscountsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFCartDiscountItem.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "UIFont+BFFont.h"
#import "BFAPIManager.h"
#import "ShoppingCart.h"


/**
 * Discount item table view cell reuse identifier.
 */
static NSString *const discountItemCellReuseIdentifier              = @"BFCartDiscountTableViewCell";
/**
 * Extension header view nib file name.
 */
static NSString *const extensionHeaderViewNibName                  = @"BFTableViewGroupedHeaderFooterView";
/**
 * Extension header view reuse identifier.
 */
static NSString *const extensionHeaderViewReuseIdentifier          = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Extension table view cell height.
 */
static CGFloat const extensionCellHeight                           = 72.0;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 30.0;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 15.0;

@interface BFCartDiscountsTableViewCellExtension ()


@end

@implementation BFCartDiscountsTableViewCellExtension

#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [[[ShoppingCart sharedCart] discounts] count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFCartDiscountItem *discount = [[ShoppingCart sharedCart] discounts][index];
    
    NSString *cellReuseIdentifier = discountItemCellReuseIdentifier;
    
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    cell.headerlabel.text = discount.name;
    cell.subheaderLabel.text = discount.valueFormatted;
    __weak __typeof__(self) weakSelf = self;
    MGSwipeButton *deleteSwipeButton = [MGSwipeButton buttonWithTitle:BFLocalizedString(kTranslationDelete, @"Delete")
                                                      backgroundColor:[UIColor BFN_pinkColor]
                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                                                 NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:sender];
                                                                 if (!indexPath) {
                                                                     return NO;
                                                                 }
                                                                 BFCartDiscountItem *discount = [[ShoppingCart sharedCart] discounts][indexPath.row];
                                                                 
                                                                 // delete the product with animation
                                                                 [weakSelf.tableView beginUpdates];
                                                                 [[ShoppingCart sharedCart] removeCartDiscountItem:discount didStartCallback:weakSelf.discountRemovalDidBeginCallback didFinishCallback:weakSelf.discountRemovalDidFinishCallback];
                                                                 [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                 [weakSelf.tableView endUpdates];
                                                                 
                                                                 
                                                                 return true;
                                                             }];
    deleteSwipeButton.titleLabel.font = [UIFont BFN_robotoMediumWithSize:16];
    // delete button to revealed with the swipe gesture
    cell.rightButtons = @[deleteSwipeButton];

    return cell;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}

#pragma mark - UITableViewDelegate

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:extensionHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:extensionHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationDiscounts, @"Discounts") uppercaseString]];
    return textHeaderView;
}

@end
