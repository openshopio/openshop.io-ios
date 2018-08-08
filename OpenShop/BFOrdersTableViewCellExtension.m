//
//  BFOrdersTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrdersTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "BFAppPreferences.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFOrderDetailViewController.h"

/**
 * Orders table view cell reuse identifier.
 */
static NSString *const orderItemReuseIdentifier                = @"BFOrdersTableViewCellIdentifier";
/**
 * Orders loading footer view reuse identifier.
 */
static NSString *const ordersLoadingFooterViewReuseIdentifier  = @"BFOrdersLoadingFooterViewIdentifier";
/**
 * Orders loading footer view nib file name.
 */
static NSString *const ordersLoadingFooterViewNibName          = @"BFTableViewLoadingHeaderFooterView";
/**
 * Orders loading footer view height.
 */
static CGFloat const ordersLoadingFooterViewHeight             = 50.0;
/**
 * Order item table view cell height.
 */
static CGFloat const orderItemHeight                           = 60.0;
/**
 * Presenting segue order data model parameter.
 */
static NSString *const segueParameterProduct                   = @"order";


@interface BFOrdersTableViewCellExtension ()


@end


@implementation BFOrdersTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)viewController {
    self = [super initWithTableViewController:viewController];
    if (self) {
        self.orders = @[];
        self.showsFooter = false;
    }
    return self;
}

- (void)didLoad {
    // register footer view
    [self.tableView registerNib:[UINib nibWithNibName:ordersLoadingFooterViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:ordersLoadingFooterViewReuseIdentifier];
}

- (void)setShowsFooter:(BOOL)showsFooter {
    _showsFooter = self.orders.count && showsFooter;
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.orders count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return orderItemHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:orderItemReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc]init];
    }
    // order item
    BFOrder *order = [self.orders objectAtIndex:index];
    
    // order number
    cell.headerlabel.text = [NSString stringWithFormat:@"%@ #%@", BFLocalizedString(kTranslationOrderElement, @"Order"), order.orderRemoteID];
    
    // order date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    cell.subheaderLabel.text = [dateFormatter stringFromDate:(NSDate *)order.date];
    
    return cell;
}

- (void)willDisplayCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    // remove separator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // prevent the cell from inheriting the table view's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // explicitly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableViewDelegate

- (UIView *)getFooterView {
    if(self.tableViewController.loadingData) {
        BFTableViewHeaderFooterView *loadingFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ordersLoadingFooterViewReuseIdentifier];
        if(!loadingFooterView) {
            loadingFooterView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:ordersLoadingFooterViewReuseIdentifier];
        }
        [loadingFooterView.activityIndicator startAnimating];
        return loadingFooterView;
    }
    return nil;
}

- (CGFloat)getFooterHeight {
    return self.showsFooter ? ordersLoadingFooterViewHeight : 0.0;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // order item
    BFOrder *order = [self.orders objectAtIndex:index];
    [self.tableViewController performSegueWithViewController:[BFOrderDetailViewController class] params:@{segueParameterProduct : order}];
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}




@end
