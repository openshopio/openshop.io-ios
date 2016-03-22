//
//  BFCartProductsTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 28.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFCartProductsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFCartProductItem.h"
#import "BFProduct.h"
#import "BFProductVariant.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFProductDetailViewController.h"
#import "BFEditCartProductViewController.h"
#import "BFAPIRequestCartProductInfo.h"
#import "BFDataRequestProductInfo.h"
#import "UIColor+BFColor.h"
#import "UIFont+BFFont.h"
#import "UIWindow+BFOverlays.h"
#import <UIKit+AFNetworking.h>
#import "StorageManager.h"
#import "BFAPIManager.h"
#import "ShoppingCart.h"

/**
 * Delay in seconds for presenting success overlay.
 */
static CGFloat const productSucessDismissDelay = 1.4f;
/**
 * Delay in seconds for presenting failure overlay.
 */
static CGFloat const productFailureDismissDelay = 2.0f;
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo                   = @"productInfo";
/**
 * Presenting segue product parameter.
 */
static NSString *const segueParameterCartProduct                   = @"cartProduct";
/**
 * Presenting segue product variants.
 */
static NSString *const segueParameterProductVariants               = @"productVariants";
/**
 * Product item table view cell reuse identifier.
 */
static NSString *const productItemCellReuseIdentifier              = @"BFCartProductTableViewCell";
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
static CGFloat const extensionCellHeight                           = 102.0f;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 20.0f;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 25.0f;
/**
 * Table view cell swipe gesture tutorial offset.
 */
static CGFloat const cellSwipeOffset                               = -50.0f;
/**
 * Table view cell swipe gesture tutorial duration (seconds).
 */
static CGFloat const cellSwipeDuration                             = 0.5f;
/**
 * Table view cell swipe gesture tutorial delay (seconds).
 */
static CGFloat const cellSwipeDelay                                = 1.0f;

@interface BFCartProductsTableViewCellExtension ()


@end

@implementation BFCartProductsTableViewCellExtension

#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [[[ShoppingCart sharedCart] products] count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFCartProductItem *productInCart = [[ShoppingCart sharedCart] products][index];
    BFProductVariant *productVariant = productInCart.productVariant;

    NSString *cellReuseIdentifier = productItemCellReuseIdentifier;
    
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    NSURL *imageURL = [NSURL URLWithString:productVariant.imageURL];
    [cell.imageContentView setImageWithURL:imageURL];
    cell.headerlabel.text = productVariant.name;
    cell.subheaderLabel.text = productInCart.totalPriceFormatted;
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@/%@", productVariant.color.name, productVariant.size.value];
    cell.detailAccesoryLabel.text = [NSString stringWithFormat:@"%@ pcs", productInCart.quantity];
    __weak __typeof__(self) weakSelf = self;
    MGSwipeButton *deleteSwipeButton = [MGSwipeButton buttonWithTitle:BFLocalizedString(kTranslationDelete, @"Delete")
                                                      backgroundColor:[UIColor BFN_pinkColor]
                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                                                 NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:sender];
                                                                 if (!indexPath) {
                                                                     return NO;
                                                                 }
                                                                 BFCartProductItem *product = [[ShoppingCart sharedCart] products][indexPath.row];
                                                                 
                                                                 // delete the product with animation
                                                                 [weakSelf.tableView beginUpdates];
                                                                 [[ShoppingCart sharedCart] removeCartProductItem:product didStartCallback:weakSelf.productRemovalDidBeginCallback didFinishCallback:weakSelf.productRemovalDidFinishCallback];
                                                                 [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                 [weakSelf.tableView endUpdates];
                                                                 
                                                                 return YES;
                                                             }];
    MGSwipeButton *editSwipeButton = [MGSwipeButton buttonWithTitle:BFLocalizedString(kTranslationEdit, @"Edit")
                                                      backgroundColor:[UIColor lightGrayColor]
                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                                                 NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:sender];
                                                                 if (!indexPath) {
                                                                     return NO;
                                                                 }
                                                                 BFCartProductItem *product = [[ShoppingCart sharedCart] products][indexPath.row];
                                                                 __typeof__(weakSelf) strongSelf = weakSelf;
                                                                 [strongSelf findProductDetailsWithCartProduct:product];
                                                                 return YES;
                                                             }];
    editSwipeButton.titleLabel.font = [UIFont BFN_robotoMediumWithSize:16];
    deleteSwipeButton.titleLabel.font = [UIFont BFN_robotoMediumWithSize:16];
    // delete button to revealed with the swipe gesture
    cell.rightButtons = @[deleteSwipeButton, editSwipeButton];
    
    // show the cell swipe tutorial for the first row if enabled
    if (self.swipeTutorialEnabled && index == 0 && self.tableViewController.view.window) {
        [cell swipeWithOffset:cellSwipeOffset duration:cellSwipeDuration delay:cellSwipeDelay];
        self.swipeTutorialEnabled = false;
    }

    return cell;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFCartProductItem *productInCart = [[ShoppingCart sharedCart] products][index];
    NSNumber *productID = productInCart.productVariant.productID;
    if (productID) {
        BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc] initWithProductIdentification:productID];
        [self.tableViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{ segueParameterProductInfo : productInfo}];
    }

    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}

#pragma mark - Product detail API request

- (void)findProductDetailsWithCartProduct:(BFCartProductItem *)cartProduct {
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(cartProduct) weakCartProduct = cartProduct;
    
    // updates all the product variants for the current cartProductItem in the Core Data
    [self.tableViewController.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
    BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc] initWithProductIdentification:cartProduct.productVariant.productID];
    [[BFAPIManager sharedManager] findProductDetailsWithInfo:productInfo completionBlock:^(NSArray * _Nullable records, id  _Nullable customResponse, NSError * _Nullable error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        __typeof__(weakCartProduct) strongCartProduct = weakCartProduct;

        [strongSelf.tableViewController.view.window dismissAllOverlaysWithCompletion:^{
            if (error) {
                [strongSelf.tableViewController.view.window showFailureOverlayWithTitle:[error localizedDescription] animated:YES];
                [strongSelf.tableViewController.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:productFailureDismissDelay];
            }
            else {
                BFProduct *product = [records firstObject];
                NSArray<BFProductVariant *> *productVariants = [product.productVariants allObjects];
                [strongSelf.tableViewController performSegueWithViewController:[BFEditCartProductViewController class] params:@{ segueParameterCartProduct: strongCartProduct,
                                                                                                                                 segueParameterProductVariants: productVariants}];
            }
        } animated:YES afterDelay:productSucessDismissDelay];
    }];

}

#pragma mark - UITableViewDelegate

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

@end
