//
//  BFEditProductColorSizeTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 17.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFEditCartProductTableViewCellExtension` manages color, size and quantity displaying in a table view.
 */
@interface BFEditCartProductTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Completion block called if the product variant color was selected.
 */
@property (nonatomic, copy) void (^didSelectProductVariantColorBlock)(BFProductVariantColor *);
/**
 * Completion block called if the product variant size was selected.
 */
@property (nonatomic, copy) void (^didSelectProductVariantSizeBlock)(BFProductVariantSize *);
/**
 * Completion block called if the product quantity was selected.
 */
@property (nonatomic, copy) void (^didSelectQuantityBlock)(NSNumber *);
/**
 * Product variant colors.
 */
@property (nonatomic, strong) NSArray<BFProductVariantColor *> *productColors;
/**
 * Selected product variant color.
 */
@property (nonatomic, strong) BFProductVariantColor *selectedProductColor;
/**
 * Product variant sizes.
 */
@property (nonatomic, strong) NSArray<BFProductVariantSize *> *productSizes;
/**
 * Selected product variant size.
 */
@property (nonatomic, strong) BFProductVariantSize *selectedProductSize;
/**
 * Selected product variant quantity.
 */
@property (nonatomic, strong) NSNumber *selectedQuantity;

@end

NS_ASSUME_NONNULL_END
