//
//  BFTableViewRangeSliderCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewCell.h"
#import <NMRangeSlider.h>

/**
 * `BFTableViewRangeSliderCell`  adds custom range slider component to the base
 * table view cell. It manages the range slider appearance and notifies with
 * value changes.
 */
@interface BFTableViewRangeSliderCell : BFTableViewCell

/**
 * The range slider.
 */
@property (nonatomic, weak) IBOutlet NMRangeSlider *rangeSlider;
/**
 * The range slider upper value label.
 */
@property (nonatomic, weak) IBOutlet UILabel *upperValueLabel;
/**
 * The range slider lower value label.
 */
@property (nonatomic, weak) IBOutlet UILabel *lowerValueLabel;
/**
 * The range slider value changed block callback.
 */
@property (nonatomic, copy) void (^sliderValueChanged)(NMRangeSlider *slider, float lowerValue, float upperValue);

/**
 * The range slider value labels constraints.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lowerValueLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *upperValueLeftConstraint;

/**
 * Updates the range slider value labels positions.
 */
- (void)updateSliderLabels;


@end
