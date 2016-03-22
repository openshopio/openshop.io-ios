//
//  BFBannerTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFBanner.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFBannerTableViewCellExtension` manages offers (banners) displaying in a table view.
 */
@interface BFBannerTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Banners data source.
 */
@property (nonatomic, strong) NSArray<BFBanner *> *banners;

@end

NS_ASSUME_NONNULL_END


