//
//  BFProductsFlexibleToolbar.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFButton.h"
#import <BLKFlexibleHeightBar.h>
#import "BFAppAppearance.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductsToolbarDelegate` is a protocol notifying the delegate with the changes on the
 * toolbar. It contains the products view type change, products sorting or filtering requests.
 */
@protocol BFProductsToolbarDelegate <NSObject>
/**
 * The products view type has changed.
 */
- (void)setProductsViewType:(BFViewType)viewType;
/**
 * Products sorting request.
 */
- (void)sortProducts;
/**
 * Products filtering request.
 */
- (void)filterProducts;

@end


/**
 * `BFProductsFlexibleToolbar` represents the products view actions toolbar.
 */
IB_DESIGNABLE
@interface BFProductsFlexibleToolbar : BLKFlexibleHeightBar <BFCustomAppearance>

/**
 * The displayed products has been filtered if set.
 */
@property (nonatomic, assign) BOOL filtering;
/**
 * The products toolbar delegate receiving selection changes.
 */
@property (nonatomic, assign) id<BFProductsToolbarDelegate> delegate;

/**
 * Updates the products view type visualization on the toolbar.
 */
- (void)updateViewType;


@end



NS_ASSUME_NONNULL_END
