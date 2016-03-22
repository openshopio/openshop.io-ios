//
//  BFStaticCategoriesTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFStaticCategoriesTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "BFAppStructure.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "BFProductsViewController.h"

/**
 * Static category table view cell reuse identifier.
 */
static NSString *const staticCategoryCellReuseIdentifier                = @"BFStaticCategoryTableViewCellIdentifier";
/**
 * Static categories loading footer view reuse identifier.
 */
static NSString *const staticCategoriesLoadingFooterViewReuseIdentifier = @"BFStaticCategoriesLoadingFooterViewIdentifier";
/**
 * Static categories loading footer view nib file name.
 */
static NSString *const staticCategoriesLoadingFooterViewNibName         = @"BFTableViewLoadingHeaderFooterView";
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo                        = @"productInfo";
/**
 * Static category table view cell height.
 */
static CGFloat const staticCategoryCellHeight                           = 47.0f;
/**
 * Static categories table view loading footer view height.
 */
static CGFloat const staticCategoriesLoadingFooterViewHeight            = 40.0f;
/**
 * Static categories table view separator footer view height.
 */
static CGFloat const staticCategoriesSeparatorFooterViewHeight          = 1.0f;
/**
 * Static categories empty header view height.
 */
static CGFloat const staticCategoriesEmptyHeaderViewHeight              = 2.0f;


@interface BFStaticCategoriesTableViewCellExtension ()

/**
 * Static categories data source.
 */
@property (nonatomic, strong) NSArray *staticCategories;

@end


@implementation BFStaticCategoriesTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        // static categories
        self.staticCategories = @[@(BFStaticMenuCategoryPopular),@(BFStaticMenuCategorySale)];
    }
    return self;
}

- (void)didLoad {
    // register header view
    [self.tableView registerNib:[UINib nibWithNibName:staticCategoriesLoadingFooterViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:staticCategoriesLoadingFooterViewReuseIdentifier];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.staticCategories count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return staticCategoryCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:staticCategoryCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticCategoryCellReuseIdentifier];
    }
    
    // static category
    BFStaticMenuCategory staticCategory = (BFStaticMenuCategory)[[self.staticCategories objectAtIndex:index]integerValue];
    // category name
    [cell.headerlabel setText:[BFAppStructure staticMenuCategoryDisplayName:staticCategory]];
    // category image
    [cell.imageContentView setImage:[BFAppStructure staticMenuCategoryIcon:staticCategory]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getFooterView {
    if(self.tableViewController.loadingData) {
        BFTableViewHeaderFooterView *loadingFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:staticCategoriesLoadingFooterViewReuseIdentifier];
        if(!loadingFooterView) {
             loadingFooterView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:staticCategoriesLoadingFooterViewReuseIdentifier];
        }
        [loadingFooterView.activityIndicator startAnimating];
        return loadingFooterView;
    }
    else {
        // separator wrapper to stop the separator height resizing
        UIView *separatorWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, staticCategoriesSeparatorFooterViewHeight)];
        // half pixel separator line
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(separatorWrapper.frame.origin.x, separatorWrapper.frame.origin.y, separatorWrapper.frame.size.width, separatorWrapper.frame.size.height/2)];
        separator.backgroundColor = [UIColor BFN_lightGreySeparatorColor];
        [separatorWrapper addSubview:separator];
        return separatorWrapper;
    }
}

- (CGFloat)getFooterHeight {
    if(self.tableViewController.loadingData) {
        return staticCategoriesLoadingFooterViewHeight;
    }
    else {
        return staticCategoriesSeparatorFooterViewHeight;
    }
}

- (CGFloat)getHeaderHeight {
    // to prevent grouped table view return the default value
    return staticCategoriesEmptyHeaderViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // static category
    BFStaticMenuCategory staticCategory = (BFStaticMenuCategory)[[self.staticCategories objectAtIndex:index]integerValue];
    
    // static category products
    BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc]init];
    [productInfo setStaticMenuCategory:@(staticCategory)];
    [self.tableViewController performSegueWithViewController:[BFProductsViewController class] params:@{ segueParameterProductInfo : productInfo}];

    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
