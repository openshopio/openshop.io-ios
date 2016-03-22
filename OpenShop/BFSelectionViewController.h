//
//  BFSelectionViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

#import "BFTableViewController.h"
#import "BFNSelection.h"
#import "BFAppAppearance.h"

/**
 * Selection delegate used to report changes in the selected items.
 */
@protocol BFSelectionViewControllerDelegate <NSObject>

@optional
/**
 * Reports selection changes in data source made in controller.
 *
 * @param controller The selection view controller.
 * @param selectedItems The items currently selected.
 * @param items The items data source.
 */
-(void)selectionController:(UIViewController *)controller
            didSelectItems:(NSArray<id<BFNSelection>> *)selectedItems
                 fromItems:(NSArray<id<BFNSelection>> *)items;
@end

/**
 * The `BFSelectionViewController` class provides user interface for items selection in a list.
 * It can be configured to support multi selection, fast navigation with alphabetical indexes
 * and filtering option with search bar.
 */
@interface BFSelectionViewController : BFTableViewController <UISearchBarDelegate>

/**
 * Navigation bar title view text.
 */
@property(nonatomic, copy) NSString *navigationTitle;
/**
 * Data source items.
 */
@property(nonatomic, strong) NSArray<id<BFNSelection>> *items;
/**
 * Data source selected items.
 */
@property(nonatomic, strong) NSArray<id<BFNSelection>> *selectedItems;
/**
 * Enables filtering interface with search bar. By default, this property is set to true.
 */
@property(nonatomic, assign) BOOL searchingEnabled;
/**
 * Allows multi selection in a list. By default, this property is set to true.
 */
@property(nonatomic, assign) BOOL multiSelection;
/**
 * Enables checkmark animations when selected. By default, this property is set to true.
 */
@property(nonatomic, assign) BOOL animateSelection;
/**
 * Enables fast navigation with alphabetical indexes. By default, this property is set to true.
 */
@property(nonatomic, assign) BOOL fastNavigation;
/**
 * Sorts data source items in alphabetical order. By default, this property is set to true.
 */
@property(nonatomic, assign) BOOL sortAlphabetically;
/**
 * All text labels are drawn in textColor. By default, this property is set to [UIColor blackColor].
 */
@property(nonatomic, retain) UIColor *textColor;
/**
 * All navigation text labels (including fast navigation) are drawn in navigationColor.
 * By default, this property is set to [UIColor BFNOrangeColor].
 */
@property(nonatomic, retain) UIColor *navigationColor;
/**
 * Selection delegate reports selection changes in data source. By default, this property is
 * set to nil.
 */
@property (nonatomic, weak) id<BFSelectionViewControllerDelegate> delegate;
/**
 * Callback block reports selection changes in data source. By default, this property is set to nil.
 */
@property (nonatomic, copy) void(^selectedItemsCallback)(NSArray<id<BFNSelection>> *, NSArray<id<BFNSelection>> *);


@end