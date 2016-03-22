//
//  BFFilterViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFModalViewController.h"
#import "BFProductFilterAttributes.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFFilterViewController` displays the products filtering options.
 */
@interface BFFilterViewController : BFModalViewController

/**
 *  Products filtering attributes.
 */
@property (nonatomic, strong) BFProductFilterAttributes *filterAttributes;
/**
 *  Products price currency.
 */
@property (nonatomic, copy) NSString *currency;
/**
 *  Products filter attributes change callback.
 */
@property (nonatomic, copy) void (^filterAttributesChanged)(BFProductFilterAttributes *filterAttributes);


@end

NS_ASSUME_NONNULL_END
