//
//  BFOnboardingPageViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFAppAppearance.h"

@class BFOnboardingViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOnboardingPageViewController` displays view controllers during the user onboarding process.
 * It is designed as a subclass of `UIPageViewController` with page control visualization.
 */
@interface BFOnboardingPageViewController : UIPageViewController <BFCustomAppearance>

/**
 * Page control.
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 * Initializes the page view controller with onboarding management controller.
 * Management controller takes care of current scrolling state and it is also
 * a page view controller datasource and delegate.
 *
 * @param controller The onboarding management controller.
 */
- (void)setupWithOnboardingController:(BFOnboardingViewController *)controller;

@end

NS_ASSUME_NONNULL_END
