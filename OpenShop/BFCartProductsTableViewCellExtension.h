//
//  BFCartProductsTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 28.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

@class BFCartProductItem;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFCartProductsTableViewCellExtension` manages product cells in cart.
 */
@interface BFCartProductsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Flag indicating the table view cell swipe tutorial presentation.
 */
@property (nonatomic, assign) BOOL swipeTutorialEnabled;
/**
 * The product removal started block callback.
 */
@property (nonatomic, copy) void (^productRemovalDidBeginCallback)();
/**
 * The product removal finished block callback.
 */
@property (nonatomic, copy) void (^productRemovalDidFinishCallback)(NSError *error);

@end

NS_ASSUME_NONNULL_END