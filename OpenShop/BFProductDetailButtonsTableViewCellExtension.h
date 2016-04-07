//
//  BFProductDetailButtonsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFProductDetailViewController.h"

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
/**
 * Table view controller managing table view presenting contents of this extension
 * which conforms to the `BFProductVariantSelectionDelegate` protocol.
 */
@property (nonatomic, strong) BFTableViewController<BFProductVariantSelectionDelegate> *tableViewController;


@end

NS_ASSUME_NONNULL_END


