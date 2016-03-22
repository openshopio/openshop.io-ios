//
//  BFOrderDetailViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewController.h"
#import "BFOrder.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFOrderDetailViewController` displays the order information details.
 */
@interface BFOrderDetailViewController : BFTableViewController <BFCustomAppearance>

/**
 * The order data model.
 */
@property (nonatomic, strong) BFOrder *order;

@end

NS_ASSUME_NONNULL_END


