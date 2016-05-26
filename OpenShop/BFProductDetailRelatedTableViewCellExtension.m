//
//  BFProductDetailRelatedTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductDetailRelatedTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIColor+BFColor.h"
#import "BFProductsTableViewCell.h"
#import "BFProductDetailViewController.h"


/**
 *  Related products empty header view height.
 */
static CGFloat const productDetailRelatedProductsEmptyHeaderFooterViewHeight = 2.0;
/**
 * Related products table view cell height.
 */
static CGFloat const productDetailRelatedProductsCellHeight                  = 220.0;
/**
 * Related products table view cell reuse identifier.
 */
static NSString *const productDetailRelatedProductsCellReuseIdentifier       = @"BFProductDetailRelatedTableViewCellIdentifier";
/**
 * Presenting segue product data model parameter.
 */
static NSString *const segueParameterProduct                                 = @"product";



@interface BFProductDetailRelatedTableViewCellExtension ()


@end


@implementation BFProductDetailRelatedTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {

    }
    return self;
}

- (void)didLoad {
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return (self.finishedLoading && [self.relatedProducts count] > 0) ? 1 : 0;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return productDetailRelatedProductsCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFProductsTableViewCell *cell = (BFProductsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:productDetailRelatedProductsCellReuseIdentifier];
    if(!cell) {
        cell = [[BFProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productDetailRelatedProductsCellReuseIdentifier];
    }

    [cell setData:self.relatedProducts];
    cell.headerlabel.text = [BFLocalizedString(kTranslationRecommended, @"Recommended") uppercaseString];
    
    __weak __typeof__(self) weakSelf = self;
    cell.productSelectionBlock = ^(BFProduct *product) {
        [weakSelf.tableViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{segueParameterProduct : product}];
    };
    
    return cell;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}

#pragma mark - UITableViewDelegate

- (CGFloat)getHeaderHeight {
    return productDetailRelatedProductsEmptyHeaderFooterViewHeight;
}



@end
