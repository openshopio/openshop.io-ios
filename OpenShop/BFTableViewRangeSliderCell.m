//
//  BFTableViewRangeSliderCell.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewRangeSliderCell.h"
#import "BFProduct.h"



@interface BFTableViewRangeSliderCell ()


@end


@implementation BFTableViewRangeSliderCell


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    // update labels position
    [self updateSliderLabels];
}


#pragma mark - Range Slider

- (void)updateSliderLabels {
    CGPoint lowerCenter = CGPointMake(self.rangeSlider.lowerCenter.x + self.rangeSlider.frame.origin.x, self.rangeSlider.center.y - self.rangeSlider.frame.size.height/2.0f);
    CGPoint upperCenter = CGPointMake(self.rangeSlider.upperCenter.x + self.rangeSlider.frame.origin.x, self.rangeSlider.center.y - self.rangeSlider.frame.size.height/2.0f);
    
    // calculate label positions
    float distance = fabs(lowerCenter.x - upperCenter.x);
    if(![@(upperCenter.x) isEqualToNumber:@(lowerCenter.x)] && distance < self.lowerValueLabel.frame.size.width) {
        lowerCenter.x -= (self.lowerValueLabel.frame.size.width-distance)/2.0;
        upperCenter.x += (self.lowerValueLabel.frame.size.width-distance)/2.0;
    }
    
    self.lowerValueLeftConstraint.constant = lowerCenter.x - self.lowerValueLabel.frame.size.width/2;
    self.upperValueLeftConstraint.constant = upperCenter.x - self.upperValueLabel.frame.size.width/2;
}

- (IBAction)rangeSliderValueChanged:(NMRangeSlider *)sender {
    if(self.sliderValueChanged) {
        self.sliderValueChanged(sender, sender.lowerValue, sender.upperValue);
    }
}




@end
