//
//  BFProductsViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFCollectionViewController.h"
#import "BFDataRequestProductInfo.h"
#import "BFProductsFlexibleToolbar.h"
#import "BFProductZoomAnimatorDelegate.h"


NS_ASSUME_NONNULL_BEGIN


/**
 * `BFProductsViewController` displays products collections.
 */
@interface BFProductsViewController :  BFCollectionViewController <BFCustomAppearance, BFProductsToolbarDelegate, BFProductZoomAnimatorDelegate>

/**
 * The products info.
 */
@property (nonatomic, strong) BFDataRequestProductInfo *productInfo;


@end

NS_ASSUME_NONNULL_END
