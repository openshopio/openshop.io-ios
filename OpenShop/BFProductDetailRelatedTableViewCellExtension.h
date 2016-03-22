//
//  BFProductDetailRelatedTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductDetailRelatedTableViewCellExtension` manages related products displaying in a table view.
 */
@interface BFProductDetailRelatedTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * The products data source.
 */
@property (nonatomic, strong) NSArray<BFProduct *> *relatedProducts;
/**
 * Flag indicating whether the product details are being fetched.
 */
@property (nonatomic, assign) BOOL finishedLoading;

@end

NS_ASSUME_NONNULL_END


