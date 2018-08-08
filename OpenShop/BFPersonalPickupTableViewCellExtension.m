//
//  BFOrderPersonalPickupTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFPersonalPickupTableViewCellExtension.h"
#import "BFSelectableTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFPaymentViewController.h"
#import "BFShippingViewController.h"
#import "ShoppingCart.h"
#import "BFBranch.h"
#import "BFBranchViewController.h"

/**
 * Personal pickup item table view cell reuse identifier.
 */
static NSString *const personalPickupItemCellReuseIdentifier       = @"BFOrderPersonalPickupTableViewCell";
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
/**
 * Presenting segue initial branch parameter.
 */
static NSString *const segueParameterInitialBranch                 = @"initialBranch";

@interface BFPersonalPickupTableViewCellExtension ()

@end

@implementation BFPersonalPickupTableViewCellExtension

#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:buttonFooterViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:buttonFooterViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.personalPickupItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return UITableViewAutomaticDimension;
}

- (CGFloat)getEstimatedHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.personalPickupItems objectAtIndex:index];
    NSString *cellReuseIdentifier = personalPickupItemCellReuseIdentifier;
    
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

- (void)willDisplayCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.personalPickupItems objectAtIndex:index];
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
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationPersonalPickup, @"Personal pickup") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.personalPickupItems objectAtIndex:index];
    if (self.didSelectDeliveryBlock) {
        self.didSelectDeliveryBlock(delivery);
    }
    [self.tableViewController performSegueWithViewController:[BFPaymentViewController class] params:nil];
}

- (void)accessoryButtonTappedForIndex:(NSInteger)index {
    BFCartDelivery *delivery = [self.personalPickupItems objectAtIndex:index];
    BFBranch *branch = delivery.branch;
    if (branch) {
        [self.tableViewController performSegueWithViewController:[BFBranchViewController class] params:@{ segueParameterInitialBranch : branch }];
    }
}

#pragma mark - Branch selection

- (void)didSelectBranch:(BFBranch *)branch {
    // branch-shiping is in relationship 1:M, we are selecting the first
    // delivery found
    BFCartDelivery *selectedDelivery = [[branch.delivery allObjects] firstObject];
    NSInteger selectedDeliveryIndex = [self.personalPickupItems indexOfObject:selectedDelivery];
    if (selectedDeliveryIndex != NSNotFound) {
        // it is necessary to manually select the row and call delegate method
        NSIndexPath *selectedDeliveryIndexPath = [self.tableViewController indexPathForIndexRowAtIndex:selectedDeliveryIndex extension:self];
        [self.tableView selectRowAtIndexPath:selectedDeliveryIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self didSelectRowAtIndex:selectedDeliveryIndex];
    }
    else {
        DDLogError(@"Selected delivery not found");
    }
}

@end
