//
//  BFTableViewCategoryHeaderFooterView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewHeaderFooterView.h"
#import "BFTableViewCellExtension.h"

/**
 * `BFTopLevelCategoryStateDelegate` protocol notifies of the state changes
 * in the top level product category displayed by the `BFTableViewCategoryHeaderFooterView`.
 */
@protocol BFTopLevelCategoryStateDelegate <NSObject>

/**
 * The category state has been changed on the specified table view cell extension.
 *
 * @param opened The category state.
 * @param extension The table view cell extension.
 */
- (void)categorySectionStateChanged:(BOOL)opened onExtension:(id<BFTableViewCellExtension>)extension;
/**
 * Perform the category action on the specified table view cell extension.
 *
 * @param extension The table view cell extension.
 */
- (void)categorySectionActionOnExtension:(id<BFTableViewCellExtension>)extension;

@end


/**
 * `BFTableViewCategoryHeaderFooterView` is the table view header view modelling the top level
 * product category. It displays the product category properties and manages the category
 * selection to display the child categories.
 */
@interface BFTableViewCategoryHeaderFooterView : BFTableViewHeaderFooterView

/**
 * The category state indicator image (opened or closed).
 */
@property (nonatomic, weak) IBOutlet UIImageView *stateIndicator;
/**
 * The table view cell extension presenting this view.
 */
@property (nonatomic, strong) id<BFTableViewCellExtension> extension;
/**
 * The category state delegate.
 */
@property (nonatomic, assign) id<BFTopLevelCategoryStateDelegate> delegate;
/**
 * Controls the category user interaction. If set to FALSE the category
 * does not expand and performs segue on touch.
 */
- (void)setExpandable:(BOOL)expandable;
/**
 * Controls the category state. The category is opened or closed with
 * an optional animation.
 */
- (void)setOpened:(BOOL)opened animated:(BOOL)animated;

@end
