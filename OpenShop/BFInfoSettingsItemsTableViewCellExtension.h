//
//  BFInfoSettingsItemsTableViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFBaseTableViewCellExtension.h"
#import "BFInfoPage.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFInfoSettingsItemsTableViewCellExtension` manages info settings items displaying in a table view.
 */
@interface BFInfoSettingsItemsTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Info pages data source.
 */
@property (nonatomic, strong) NSArray<BFInfoPage *> *infoPages;

/**
 * Refreshes extension's data source.
 */
- (void)refreshDataSource;

@end



NS_ASSUME_NONNULL_END


