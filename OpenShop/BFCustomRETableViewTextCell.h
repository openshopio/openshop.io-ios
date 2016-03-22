//
//  BFCustomRETableViewTextCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import <RETableViewManager.h>


/**
 * `BFCustomRETableViewTextCell` extends the `RETableViewTextCell` with an option to specify
 * the table view cell appearance customization block. The block is applied before the table
 * view cell gets displayed.
 */
@interface BFCustomRETableViewTextCell : RETableViewTextCell

/*
 * The table view cell appearance customization block.
 */
@property (nonatomic, copy) void(^appearanceBlock)(RETableViewTextCell *);

@end
