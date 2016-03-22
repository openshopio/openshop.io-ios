//
//  BFCategoriesViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewController.h"
#import "BFTableViewCategoryHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFCategoriesViewController` displays product categories heirerchy.
 */
@interface BFCategoriesViewController : BFTableViewController  <BFCustomAppearance, BFTopLevelCategoryStateDelegate>

/**
 * Flag indicating whether the products static categories are displayed.
 */
@property (nonatomic, assign) IBInspectable BOOL displaysStaticCategories;

@end

NS_ASSUME_NONNULL_END


