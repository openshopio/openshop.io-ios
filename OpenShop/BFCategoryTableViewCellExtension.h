//
//  BFCategoryTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFCategory.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFCategoryTableViewCellExtension` manages products categories displaying in a table view.
 * Top level category is presented with a header view and the child categories are modeled
 * by the table view rows.
 */
@interface BFCategoryTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Top level category data source object.
 */
@property (nonatomic, strong, nullable) BFCategory *category;
/**
 * Controls the top level category state. The category is opened or closed with an optional animation.
 */
- (void)setOpened:(BOOL)opened animated:(BOOL)animated interaction:(BOOL)interaction;

@end



NS_ASSUME_NONNULL_END


