//
//  BFInfoSettingsItemsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFInfoSettingsItemsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "BFAppStructure.h"
#import "User.h"
#import "BFOpenShopOnboardingViewController.h"
#import "BFInfoPageViewController.h"
#import "BFSettingsViewController.h"
#import "BFBranchViewController.h"

/**
 * Info settings item table view cell reuse identifier.
 */
static NSString *const infoSettingsItemCellReuseIdentifier         = @"BFMoreTableViewCellIdentifier";
/**
 * Button footer view reuse identifier.
 */
static NSString *const buttonFooterViewReuseIdentifier             = @"BFTableViewButtonHeaderFooterViewIdentifier";
/**
 * Info settings items header view reuse identifier.
 */
static NSString *const infoSettingsItemsHeaderViewReuseIdentifier  = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Info settings items header view nib file name.
 */
static NSString *const infoSettingsItemsHeaderViewNibName          = @"BFTableViewGroupedHeaderFooterView";
/**
 * Button footer view nib file name.
 */
static NSString *const buttonFooterViewNibName                     = @"BFTableViewButtonHeaderFooterView";
/**
 * Presenting segue info page parameter.
 */
static NSString *const segueParameterInfoPage                      = @"infoPage";
/**
 * Info settings item table view cell height.
 */
static CGFloat const infoSettingsItemCellHeight                    = 42.0;
/**
 * Info settings items header view height.
 */
static CGFloat const infoSettingsItemsHeaderViewHeight             = 40.0;
/**
 * Button footer view height.
 */
static CGFloat const buttonFooterViewHeight                        = 100.0;
/**
 * Info settings items empty footer view height.
 */
static CGFloat const infoSettingsItemsEmptyFooterViewHeight        = 15.0;



@interface BFInfoSettingsItemsTableViewCellExtension ()

/**
 * Info settings items data source.
 */
@property (nonatomic, strong) NSArray *infoSettingsItems;

/**
 * Flag indicating whether the user is currently logged in.
 */
@property (nonatomic, assign) BOOL userLoggedIn;

@end


@implementation BFInfoSettingsItemsTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        // info settings items
        self.infoSettingsItems = @[@(BFInfoSettingsItemBranches),@(BFInfoSettingsItemCountry)];
    }
    return self;
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:infoSettingsItemsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:infoSettingsItemsHeaderViewReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:buttonFooterViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:buttonFooterViewReuseIdentifier];
    // refresh data source
    [self refreshDataSource];
}


#pragma mark - Data Source

- (void)refreshDataSource {
    // user state
    self.userLoggedIn = [User isLoggedIn];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.infoSettingsItems count] + [self.infoPages count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return infoSettingsItemCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    // table view cell
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:infoSettingsItemCellReuseIdentifier];
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoSettingsItemCellReuseIdentifier];
    }
    
    // info settings items
    if(index < [self.infoSettingsItems count]) {
        // info settings item
        BFInfoSettingsItem infoSettingsItem = (BFInfoSettingsItem)[[self.infoSettingsItems objectAtIndex:index]integerValue];
        // item text
        [cell.headerlabel setText:[BFAppStructure infoSettingsItemDisplayName:infoSettingsItem]];
    }
    // info pages
    else {
        NSUInteger infoPageIndex = index - [self.infoSettingsItems count];
        // info page
        BFInfoPage *infoPage = (BFInfoPage *)[self.infoPages objectAtIndex:infoPageIndex];
        // item text
        [cell.headerlabel setText:infoPage.title];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:infoSettingsItemsHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:infoSettingsItemsHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationOpenShop, @"OpenShop") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return infoSettingsItemsHeaderViewHeight;
}

- (UIView *)getFooterView {
    if(self.userLoggedIn) {
        BFTableViewHeaderFooterView *buttonFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:buttonFooterViewReuseIdentifier];
        if(!buttonFooterView) {
            buttonFooterView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:buttonFooterViewReuseIdentifier];
        }
        [buttonFooterView.actionButton setTitle:BFLocalizedString(kTranslationLogout, @"Logout") forState:UIControlStateNormal];
        // logout button action
        __weak __typeof__(self) weakSelf = self;
        buttonFooterView.actionButtonBlock = ^() {
            // log user out
            [[User sharedUser]logout];
            // present the onboarding view
            [weakSelf.tableViewController performSegueWithViewController:[BFOpenShopOnboardingViewController class] params:nil];
        };
        return buttonFooterView;
    }
    return nil;
}

- (CGFloat)getFooterHeight {
    // button footer view if the user is currently logged in
    return self.userLoggedIn ? buttonFooterViewHeight : infoSettingsItemsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    if(index < [self.infoSettingsItems count]) {
        // info settings item
        BFInfoSettingsItem infoSettingsItem = (BFInfoSettingsItem)[[self.infoSettingsItems objectAtIndex:index]integerValue];
        switch (infoSettingsItem) {
            // country and language settings
            case BFInfoSettingsItemCountry:
                [self.tableViewController performSegueWithViewController:[BFSettingsViewController class] params:nil];
                break;
            // shop branches
            case BFInfoSettingsItemBranches:
                [self.tableViewController performSegueWithViewController:[BFBranchViewController class] params:nil];
                break;
            default:
                break;
        }
    }
    else {
        NSUInteger infoPageIndex = index - [self.infoSettingsItems count];
        // info page
        BFInfoPage *infoPage = (BFInfoPage *)[self.infoPages objectAtIndex:infoPageIndex];
        [self.tableViewController performSegueWithViewController:[BFInfoPageViewController class] params:@{segueParameterInfoPage : infoPage}];
    }
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
