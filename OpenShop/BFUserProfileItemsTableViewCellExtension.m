//
//  BFUserProfileItemsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFUserProfileItemsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "BFAppStructure.h"
#import "User.h"
#import "BFOpenShopOnboardingViewController.h"
#import "BFUserDetailsViewController.h"
#import "BFWishlistViewController.h"
#import "BFOrdersViewController.h"

/**
 * User profile item table view cell reuse identifier.
 */
static NSString *const userProfileItemCellReuseIdentifier        = @"BFMoreTableViewCellIdentifier";
/**
 * User profile items header view reuse identifier.
 */
static NSString *const userProfileItemsHeaderViewReuseIdentifier = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * User profile items header view nib file name.
 */
static NSString *const userProfileItemsHeaderViewNibName         = @"BFTableViewGroupedHeaderFooterView";
/**
 * User profile item table view cell height.
 */
static CGFloat const userProfileItemCellHeight                   = 42.0;
/**
 * User profile items header view height.
 */
static CGFloat const userProfileItemsHeaderViewHeight            = 50.0;
/**
 * User profile items empty footer view height.
 */
static CGFloat const userProfileItemsEmptyFooterViewHeight       = 15.0;



@interface BFUserProfileItemsTableViewCellExtension ()

/**
 * User profile items data source.
 */
@property (nonatomic, strong) NSArray *userProfileItems;

@end


@implementation BFUserProfileItemsTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        // user profile items
        [self refreshDataSource];
    }
    return self;
}

- (void)didLoad {
    // register header view
    [self.tableView registerNib:[UINib nibWithNibName:userProfileItemsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:userProfileItemsHeaderViewReuseIdentifier];
}


#pragma mark - Data Source

- (void)refreshDataSource {
    // user profile items
    if([User isLoggedIn]) {
        self.userProfileItems = @[@(BFUserProfileItemOrders),@(BFUserProfileItemMyProfile),@(BFUserProfileItemMyWishlist)];
    }
    else {
        self.userProfileItems = @[@(BFUserProfileItemLogin)];
    }
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.userProfileItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return userProfileItemCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:userProfileItemCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userProfileItemCellReuseIdentifier];
    }

    // user profile item
    BFUserProfileItem userProfileItem = (BFUserProfileItem)[[self.userProfileItems objectAtIndex:index]integerValue];
    // item text
    [cell.headerlabel setText:[BFAppStructure userProfileItemDisplayName:userProfileItem]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:userProfileItemsHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:userProfileItemsHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationUserProfile, @"Profile")uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return userProfileItemsHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return userProfileItemsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFUserProfileItem userProfileItem = (BFUserProfileItem)[[self.userProfileItems objectAtIndex:index]integerValue];
    
    switch (userProfileItem) {
        // user login
        case BFUserProfileItemLogin:
            [self.tableViewController performSegueWithViewController:[BFOpenShopOnboardingViewController class] params:nil];
            break;
        // user details
        case BFUserProfileItemMyProfile:
            [self.tableViewController performSegueWithViewController:[BFUserDetailsViewController class] params:nil];
            break;
            // user details
        case BFUserProfileItemMyWishlist:
            [self.tableViewController performSegueWithViewController:[BFWishlistViewController class] params:nil];
            break;
            // orders
        case BFUserProfileItemOrders:
            [self.tableViewController performSegueWithViewController:[BFOrdersViewController class] params:nil];
            break;
        default:
            break;
    }
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
