//
//  BFOnboardingPageViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingPageViewController.h"
#import "BFOnboardingViewController.h"
#import "BFAppAppearance.h"
#import "UIColor+BFColor.h"

@interface BFOnboardingPageViewController ()

@end

@implementation BFOnboardingPageViewController


#pragma mark - Initialization

- (void)setupWithOnboardingController:(BFOnboardingViewController *)controller {
    // page controller datasource and delegate
    self.delegate = controller;
    self.dataSource = !controller.pageControlHidden || controller.swipingEnabled ? controller : nil;
    // currently visible controller
    if([controller.viewControllers firstObject]) {
        [self setViewControllers:@[[controller.viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    // scrolling delegate
    id<UIScrollViewDelegate> scrollingDelegate = (id<UIScrollViewDelegate>)controller;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:scrollingDelegate];
            [(UIScrollView *)view setScrollEnabled:controller.swipingEnabled];
        }
        if ([view isKindOfClass:[UIPageControl class]]) {
            self.pageControl = (UIPageControl *)view;
            [(UIPageControl *)view setHidden:controller.pageControlHidden];
            [(UIPageControl *)view setUserInteractionEnabled:controller.swipingEnabled];
        }
    }
}

#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // page control appearance
    [BFAppAppearance customizePageControlBackgroundColor:[UIColor clearColor] currentPageIndicatorTintColor:[UIColor whiteColor] pageIndicatorTintColor:[UIColor BFN_greyColorWithAlpha:0.3] containedInClasses:[self class], nil];
}


@end
