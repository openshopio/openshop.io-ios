//
//  BFProductDetailButtonsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductDetailButtonsTableViewCellExtension` manages product detail action buttons displaying in a table view.
 */
@interface BFProductDetailButtonsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Product variant colors.
 */
@property (nonatomic, strong) NSArray<BFProductVariantColor *> *productColors;
/**
 * Product variant sizes.
 */
@property (nonatomic, strong) NSArray<BFProductVariantSize *> *productSizes;
/**
 * Selected product variant color.
 */
@property (nonatomic, strong) BFProductVariantColor *selectedProductColor;
/**
 * Selected product variant size.
 */
@property (nonatomic, strong) BFProductVariantSize *selectedProductSize;
/**
 * Product datasource object.
 */
@property (nonatomic, strong, nullable) BFProduct *product;
/**
 * Flag indicating whether the product details are being fetched.
 */
@property (nonatomic, assign) BOOL finishedLoading;


@end

NS_ASSUME_NONNULL_END


