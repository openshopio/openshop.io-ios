//
//  BFOnboardingContentViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingContentViewController.h"


@interface BFOnboardingContentViewController () {

}

@end

@implementation BFOnboardingContentViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    
}


#pragma mark - BFOnboardingContentViewState Protocol

- (void)visibilityChangedWithPercentage:(NSInteger)percentage {
    // adjust elements visibility
    self.headerLabel.alpha = percentage;
    self.subheaderLabel.alpha = percentage;
    self.imageView.alpha = percentage;
}


#pragma mark - Onboarding Skip

- (IBAction)skipOnboarding:(id)sender {
    [self.delegate skipOnboarding:sender];
}



@end
