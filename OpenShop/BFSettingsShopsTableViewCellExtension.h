//
//  BFSettingsShopsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFShop.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFSettingsShopsTableViewCellExtension` manages shops displaying in a table view
 * in the info settings section.
 */
@interface BFSettingsShopsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Shops data source.
 */
@property (nonatomic, strong) NSArray<BFShop *> *shops;

@end



NS_ASSUME_NONNULL_END


