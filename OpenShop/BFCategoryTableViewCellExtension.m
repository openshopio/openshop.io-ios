//
//  BFCategoryTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCategoryTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "BFCategoriesViewController.h"
#import "BFTableViewCategoryHeaderFooterView.h"
#import "BFProductsViewController.h"

/**
 * Category table view cell reuse identifier.
 */
static NSString *const categoryCellReuseIdentifier       = @"BFCategoryTableViewCellIdentifier";
/**
 * Top level category table view header view reuse identifier.
 */
static NSString *const categoryHeaderViewReuseIdentifier = @"BFTableViewCategoryHeaderFooterViewIdentifier";
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo         = @"productInfo";
/**
 * Category table view cell height.
 */
static CGFloat const categoryCellHeight                  = 42.0f;
/**
 * Top level category table view header view height.
 */
static CGFloat const categoryHeaderViewHeight            = 42.0f;


@interface BFCategoryTableViewCellExtension ()

/**
 * Top level category table view header view
 */
@property (nonatomic, weak) BFTableViewCategoryHeaderFooterView *categoryHeaderView;
/**
 * Top level category state (opened or closed).
 */
@property (nonatomic, assign) BOOL opened;

@end


@implementation BFCategoryTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        self.category = nil;
        self.opened = false;
    }
    return self;
}

- (void)didLoad {
    // register top level category header view
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BFTableViewCategoryHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:categoryHeaderViewReuseIdentifier];
}

- (void)setOpened:(BOOL)opened animated:(BOOL)animated interaction:(BOOL)interaction {
    _opened = opened;
    // change top level category state
    if(self.categoryHeaderView && interaction) {
        [self.categoryHeaderView setOpened:_opened animated:animated];
    }
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return self.opened ? [[self.category children]count] : 0;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return categoryCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:categoryCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellReuseIdentifier];
    }
    
    // child category
    BFCategory *childCategory = (BFCategory *)[[self.category children] objectAtIndex:index];
    // category name
    [cell.headerlabel setText:childCategory.name];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewCategoryHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:categoryHeaderViewReuseIdentifier];
    if(!headerView) {
        headerView = [[BFTableViewCategoryHeaderFooterView alloc] initWithReuseIdentifier:categoryHeaderViewReuseIdentifier];
    }

    // top level category name
    [headerView.headerlabel setText:self.category.name];
    // table view cell extension
    headerView.extension = self;
    // category state delegate
    if([self.tableViewController conformsToProtocol:@protocol(BFTopLevelCategoryStateDelegate)]) {
        headerView.delegate = (id <BFTopLevelCategoryStateDelegate>)self.tableViewController;
    }
    // header view user interaction
    [headerView setExpandable:([self.category.children count] != 0)];
    // header view state
    [headerView setOpened:self.opened animated:NO];
    return headerView;
}

- (CGFloat)getHeaderHeight {
    return categoryHeaderViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // child category
    BFCategory *childCategory = (BFCategory *)[[self.category children] objectAtIndex:index];

    // category products
    BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc]init];
    [productInfo setCategoryID:childCategory.originalID];
    [self.tableViewController performSegueWithViewController:[BFProductsViewController class] params:@{segueParameterProductInfo : productInfo}];
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
