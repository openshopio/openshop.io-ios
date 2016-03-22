//
//  BFProductDetailDescriptionTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import <DTAttributedTextView.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductDetailDescriptionTableViewCellExtension` displays product description text.
 */
@interface BFProductDetailDescriptionTableViewCellExtension : BFBaseTableViewCellExtension <DTAttributedTextContentViewDelegate>

/**
 * Flag indicating whether the product details are being fetched.
 */
@property (nonatomic, assign) BOOL finishedLoading;
/**
 * The product data model.
 */
@property (nonatomic, strong, nullable) BFProduct *product;

@end

NS_ASSUME_NONNULL_END


