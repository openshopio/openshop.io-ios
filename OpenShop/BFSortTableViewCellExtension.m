//
//  BFSortTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSortTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "BFAppStructure.h"
#import "User.h"
#import "BFOpenShopOnboardingViewController.h"
#import "BFInfoPageViewController.h"
#import "BFAppPreferences.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "BFProductsViewController.h"

/**
 * Sort option table view cell reuse identifier.
 */
static NSString *const sortOptionCellReuseIdentifier         = @"BFSortTableViewCellIdentifier";
/**
 * Sort options header view reuse identifier.
 */
static NSString *const sortOptionsHeaderViewReuseIdentifier  = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Sort options header view nib file name.
 */
static NSString *const sortOptionsHeaderViewNibName          = @"BFTableViewGroupedHeaderFooterView";
/**
 * Sort option table view cell height.
 */
static CGFloat const sortOptionCellHeight                    = 42.0;
/**
 * Sort options header view height.
 */
static CGFloat const sortOptionsHeaderViewHeight             = 50.0;
/**
 * Sort options empty footer view height.
 */
static CGFloat const sortOptionsEmptyFooterViewHeight        = 15.0;
/**
 * Sort option selection overlay dismiss delay.
 */
static CGFloat const selectionFinishDelay                    = 0.5;



@interface BFSortTableViewCellExtension ()

/**
 * Sort options data source.
 */
@property (nonatomic, strong) NSArray *options;
/**
 * Checkmark view for each sort option.
 */
@property(nonatomic, strong) NSMutableDictionary *checkmarks;

@end


@implementation BFSortTableViewCellExtension


#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:sortOptionsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:sortOptionsHeaderViewReuseIdentifier];
    // sort options
    self.options = @[@(BFSortTypePopularity), @(BFSortTypeNewest), @(BFSortTypeHighestPrice), @(BFSortTypeLowestPrice)];
    // checkmark views
    _checkmarks = [[NSMutableDictionary alloc]init];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.options count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return sortOptionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    // table view cell
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:sortOptionCellReuseIdentifier];
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortOptionCellReuseIdentifier];
    }

    // sort option
    BFSortType sortOption = (BFSortType)[[self.options objectAtIndex:index]integerValue];
    // option text
    [cell.headerlabel setText:[BFAppStructure sortTypeDisplayName:sortOption]];
    // checkmark view
    [cell.checkmark setSelected:[self isSortOptionSelected:sortOption] withAnimation:false];

    // register callback for value change
    [cell.checkmark addTarget:self action:@selector(checkmarkSelected:) forControlEvents:UIControlEventValueChanged];
    // save checkmark view
    [_checkmarks setObject:(BFNCheckmarkView *)cell.checkmark forKey:@(sortOption)];
    
    return cell;
}


#pragma mark - Shop Selection

- (void)selectSortOption:(NSNumber *)sortOption {
    // save selected option
    [[BFAppPreferences sharedPreferences]setPreferredSortType:sortOption];
    // deselect unselected checkmarks
    [self deselectCheckmarks];

    // dismiss view controller
    [self performSelector:@selector(finishSelection) withObject:nil afterDelay:selectionFinishDelay];
}

- (void)finishSelection {
    // dismiss view controller
    [self.tableViewController performSegueWithViewController:[BFProductsViewController class] params:nil];
}

- (BOOL)isSortOptionSelected:(BFSortType)sortOption {
    // selected sort option
    BFSortType selectedSortOption = (BFSortType)[[[BFAppPreferences sharedPreferences]preferredSortType]integerValue];

    // compare sort options
    return selectedSortOption == sortOption;
}

- (IBAction)checkmarkSelected:(id)sender {
    BFNCheckmarkView *checkmark = (BFNCheckmarkView *)sender;
    if(checkmark) {
        NSNumber *sortOption = [self selectedSortOptionForCheckmark:checkmark];
        if(sortOption) {
            // select sort option
            [self selectSortOption:sortOption];
        }
    }
}

- (NSNumber *)selectedSortOptionForCheckmark:(BFNCheckmarkView *)checkmark {
    NSArray *keys = [_checkmarks allKeysForObject:checkmark];
    return keys && keys.count ? [keys firstObject] : nil;
}

- (void)deselectCheckmarks {
    // deselect all checkmarks
    [_checkmarks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(((BFNCheckmarkView *)obj).isSelected) {
            // selected sort option
            BFSortType sortOption = (BFSortType)[key integerValue];
            // deselect unselected checkmark
            if(![self isSortOptionSelected:sortOption]) {
                [(BFNCheckmarkView *)obj setSelected:false withAnimation:true];
            }
        }
    }];
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:sortOptionsHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:sortOptionsHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationSortBy, @"Sort by") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return sortOptionsHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    // button footer view if the user is currently logged in
    return sortOptionsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // selected sort option
    NSNumber *sortOption = [self.options objectAtIndex:index];

    BFNCheckmarkView *checkmark = [_checkmarks objectForKey:sortOption];
    // select sort option
    if(checkmark && !checkmark.isSelected) {
        [checkmark setSelected:true withAnimation:true];
        [self selectSortOption:sortOption];
    }
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
