//
//  BFEditProductInCartViewController.h
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFModalViewController.h"

@class BFCartProductItem, BFProductVariant;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFEditProductInCartViewController` displays edit product in the cart as the modal view.
 */
@interface BFEditCartProductViewController : BFModalViewController

/**
 * Product in the cart which is being edited.
 */
@property (nonatomic, strong) BFCartProductItem *cartProduct;
/**
 * Possible variants for the product in the cart which is is being edited.
 */
@property (nonatomic, strong) NSArray<BFProductVariant *> *productVariants;

@end

NS_ASSUME_NONNULL_END
