//
//  BFFilterPriceTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFFilterPriceTableViewCellExtension.h"
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
#import "BFTableViewRangeSliderCell.h"

/**
 * Filter price range table view cell reuse identifier.
 */
static NSString *const filterPriceCellReuseIdentifier        = @"BFFilterPriceTableViewCellIdentifier";
/**
 * Filter price range header view reuse identifier.
 */
static NSString *const filterPriceHeaderViewReuseIdentifier  = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Filter price range header view nib file name.
 */
static NSString *const filterPriceHeaderViewNibName          = @"BFTableViewGroupedHeaderFooterView";
/**
 * Filter price range table view cell height.
 */
static CGFloat const filterPriceCellHeight                   = 90.0;
/**
 * Filter price range header view height.
 */
static CGFloat const filterPriceHeaderViewHeight             = 50.0;
/**
 * Filter price range empty footer view height.
 */
static CGFloat const filterPriceEmptyFooterViewHeight        = 15.0;


@interface BFFilterPriceTableViewCellExtension ()

@end


@implementation BFFilterPriceTableViewCellExtension


#pragma mark - Initialization

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:filterPriceHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:filterPriceHeaderViewReuseIdentifier];

}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return 1;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return filterPriceCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    // table view cell
    BFTableViewRangeSliderCell *cell = (BFTableViewRangeSliderCell *)[self.tableView dequeueReusableCellWithIdentifier:filterPriceCellReuseIdentifier];
    if(!cell) {
        cell = [[BFTableViewRangeSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filterPriceCellReuseIdentifier];
    }

    // check if the range bounds do not match
    BOOL rangeAvailable = ![@([self.productPriceRange.max floatValue])isEqualToNumber:@([self.productPriceRange.min floatValue])];
    
    if (rangeAvailable) {
        // min and max range values
        cell.rangeSlider.maximumValue = [self.productPriceRange.max floatValue];
        cell.rangeSlider.minimumValue = [self.productPriceRange.min floatValue];
        
        // selected range values
        if (self.selectedPriceRange) {
            cell.rangeSlider.upperValue = [self.selectedPriceRange.max floatValue];
            cell.rangeSlider.lowerValue = [self.selectedPriceRange.min floatValue];
        }
        else {
            cell.rangeSlider.upperValue = [self.productPriceRange.max floatValue];
            cell.rangeSlider.lowerValue = [self.productPriceRange.min floatValue];
        }
        cell.rangeSlider.stepValue = 1.0;
        
        // range selection
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(cell) weakCell = cell;
        cell.sliderValueChanged = ^(NMRangeSlider *slider, float lowerValue, float upperValue) {
            __typeof__(weakSelf) strongSelf = weakSelf;
            if(!weakSelf.selectedPriceRange) {
                weakSelf.selectedPriceRange = [[BFProductPriceRange alloc]init];
            }
            strongSelf.selectedPriceRange.min = @(lowerValue);
            strongSelf.selectedPriceRange.max = @(upperValue);
            [strongSelf updateSliderLabelsForCell:weakCell];
            if(strongSelf.priceRangeChanged) {
                strongSelf.priceRangeChanged((BFProductPriceRange *)strongSelf.selectedPriceRange);
            }
        };

        [cell.rangeSlider layoutIfNeeded];
        [self updateSliderLabelsForCell:cell];
    }
    else {
        cell.headerlabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)cell.rangeSlider.minimumValue, self.currency];
    }
    
    cell.lowerValueLabel.hidden = !rangeAvailable;
    cell.upperValueLabel.hidden = !rangeAvailable;
    cell.rangeSlider.hidden = !rangeAvailable;
    cell.headerlabel.hidden = rangeAvailable;
    
    return cell;
}

- (void)updateSliderLabelsForCell:(BFTableViewRangeSliderCell *)cell {
    if(self.selectedPriceRange) {
        cell.lowerValueLabel.text = [NSString stringWithFormat:@"%d %@", [self.selectedPriceRange.min integerValue], self.currency];
        cell.upperValueLabel.text = [NSString stringWithFormat:@"%d %@", [self.selectedPriceRange.max integerValue], self.currency];
    }
    else {
        cell.lowerValueLabel.text = [NSString stringWithFormat:@"%ld %@", (long)[self.productPriceRange.min integerValue], self.currency];
        cell.upperValueLabel.text = [NSString stringWithFormat:@"%ld %@", (long)[self.productPriceRange.max integerValue], self.currency];
    }
    [cell updateSliderLabels];
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:filterPriceHeaderViewReuseIdentifier];
    if(!textHeaderView) {
         textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:filterPriceHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationPrice, @"Price") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return filterPriceHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return filterPriceEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
