//
//  BFSettingsShopsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSettingsShopsTableViewCellExtension.h"
#import "BFViewController+BFChangeShop.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "UIColor+BFColor.h"
#import "BFAppStructure.h"
#import "User.h"
#import "BFOpenShopOnboardingViewController.h"
#import "BFInfoPageViewController.h"
#import "BFAppPreferences.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "BFMoreViewController.h"

/**
 * Shop table view cell reuse identifier.
 */
static NSString *const shopCellReuseIdentifier         = @"BFSettingsTableViewCellIdentifier";
/**
 * Shops header view reuse identifier.
 */
static NSString *const shopsHeaderViewReuseIdentifier  = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Shops header view nib file name.
 */
static NSString *const shopsHeaderViewNibName          = @"BFTableViewGroupedHeaderFooterView";
/**
 * Shop table view cell height.
 */
static CGFloat const shopCellHeight                    = 42.0;
/**
 * Shops header view height.
 */
static CGFloat const shopsHeaderViewHeight             = 50.0;
/**
 * Shops empty footer view height.
 */
static CGFloat const shopsEmptyFooterViewHeight        = 15.0;



@interface BFSettingsShopsTableViewCellExtension ()

/**
 * Checkmark view for each shop saved with shop identifier.
 */
@property(nonatomic, strong) NSMutableDictionary *checkmarks;

@end


@implementation BFSettingsShopsTableViewCellExtension


#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:shopsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:shopsHeaderViewReuseIdentifier];
    // checkmark views
    _checkmarks = [[NSMutableDictionary alloc]init];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.shops count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return shopCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    // table view cell
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:shopCellReuseIdentifier];
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopCellReuseIdentifier];
    }

    // info settings item
    BFShop *shop = (BFShop *)[self.shops objectAtIndex:index];
    // item text
    [cell.headerlabel setText:shop.name];
    // checkmark view
    [cell.checkmark setSelected:[self isShopSelected:shop] withAnimation:false];

    // register callback for value change
    [cell.checkmark addTarget:self action:@selector(checkmarkSelected:) forControlEvents:UIControlEventValueChanged];
    // save checkmark view
    if(shop.shopID) {
        [_checkmarks setObject:(BFNCheckmarkView *)cell.checkmark forKey:(NSNumber *)shop.shopID];
    }
    
    return cell;
}


#pragma mark - Shop Selection

- (void)selectShop:(NSNumber *)shopIdentification {
    [self.tableViewController selectShop:shopIdentification completion:^{
        [self.tableViewController performSegueWithViewController:[BFMoreViewController class] params:nil];
    }];
    // deselect unselected checkmarks
    [self deselectCheckmarks];
}

- (BOOL)isShopSelected:(BFShop *)shop {
    // selected shop
    NSNumber *selectedShop =[[BFAppPreferences sharedPreferences]selectedShop];
    // compare shops identification
    return shop.shopID && [selectedShop isEqualToNumber:(NSNumber *)shop.shopID];
}

- (IBAction)checkmarkSelected:(id)sender {
    BFNCheckmarkView *checkmark = (BFNCheckmarkView *)sender;
    if(checkmark) {
        // shop change
        NSNumber *shopIdentification = [self selectedShopIdentificationForCheckmark:checkmark];
        if(shopIdentification) {
            // select shop with language code
            [self selectShop:shopIdentification];
        }
    }
}

- (NSNumber *)selectedShopIdentificationForCheckmark:(BFNCheckmarkView *)checkmark {
    NSArray *keys = [_checkmarks allKeysForObject:checkmark];
    return [keys firstObject];
}

- (void)deselectCheckmarks {
    // deselect all checkmarks
    [_checkmarks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(((BFNCheckmarkView *)obj).isSelected) {
            // selected shop
            NSNumber *selectedShop =[[BFAppPreferences sharedPreferences]selectedShop];
            // deselect unselected checkmark
            if(![key isEqualToNumber:selectedShop]) {
                [(BFNCheckmarkView *)obj setSelected:false withAnimation:true];
            }
        }
    }];
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:shopsHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:shopsHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationCountry, @"Country") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return shopsHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    // button footer view if the user is currently logged in
    return shopsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // selected shop
    BFShop *shop = (BFShop *)[self.shops objectAtIndex:index];
    if(shop.shopID) {
        BFNCheckmarkView *checkmark = [_checkmarks objectForKey:(NSNumber *)shop.shopID];
        // select shop with language code
        if(checkmark && !checkmark.isSelected) {
            [checkmark setSelected:true withAnimation:true];
            [self selectShop:shop.shopID];
        }
    }
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
