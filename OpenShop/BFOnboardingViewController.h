//
//  BFOnboardingViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFOnboardingPageViewController.h"
#import "BFOnboardingContentViewController.h"
#import "BFViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class BFOnboardingViewController;
@class BFOnboardingPageViewController;

/**
 * Onboarding completion block type.
 */
typedef void (^BFOnboardingCompletionBlock)(BOOL skipped);
/**
 * Onboarding after login block type.
 */
typedef void (^BFOnboardingAfterLoginBlock)(UIViewController *viewController, BOOL skipped);
/**
 * Onboarding effect block type.
 */
typedef void (^BFOnboardingEffectBlock)(BFOnboardingPageViewController *pageViewController, NSArray *controllers, NSInteger current, NSInteger upcoming, NSInteger percentage);
/**
 * Onboarding skip block type.
 */
typedef void (^BFOnboardingSkipBlock)(NSArray *controllers, NSInteger current);
/**
 * Onboarding did appear block type.
 */
typedef void (^BFOnboardingDidAppearBlock)(BFOnboardingViewController *controller);


/**
 * `BFOnboardingViewController` manages user's onboarding process. It is designed as a manager of
 * `UIPageViewController` controlling its scrolling state and view pages datasource and delegate.
 * It also suplies effects during the view controllers transition and properties such as onboarding skip,
 * background image modification and effects.
 */
@interface BFOnboardingViewController : BFViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, BFOnboardingControllerDelegate>

/**
 * Onboarding page view controller.
 */
@property (nonatomic, strong) BFOnboardingPageViewController *pageViewController;
/**
 * Onboarding view controllers to be displayed in page view controller.
 */
@property (nonatomic, strong) NSArray *viewControllers;
/**
 * Onboarding background image.
 */
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
/**
 * Onboarding skip button.
 */
@property (nonatomic, weak) IBOutlet UIButton *skipButton;
/**
 * Onboarding background image dimming view.
 */
@property (nonatomic, weak) IBOutlet UIView *dimView;
/**
 * Dims view below the onboarding page view controller.
 */
@property (nonatomic, assign) BOOL dimsBackground;
/**
 * Blurs view below the onboarding page view controller.
 */
@property (nonatomic, assign) BOOL blursBackground;
/**
 * User can skip the onboarding process.
 */
@property (nonatomic, assign) BOOL allowsSkip;
/**
 * Pages transition with swipe gesture.
 */
@property (nonatomic, assign) BOOL swipingEnabled;
/**
 * Onboarding page control visiblity.
 */
@property (nonatomic, assign) BOOL pageControlHidden;
/**
 * Onboarding page control alpha property.
 */
@property (nonatomic, assign) CGFloat pageControlAlpha;
/**
 * Onboarding background image dimming view.
 */
@property (nonatomic, weak) IBOutlet UIView *containerDimView;
/**
 * Child container content height AutoLayout constraint.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
/**
 * Onboarding container view bottom autolayout constraint.
 * Enables automatic scroll if the keyboard appears.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerBottomConstraint;

/**
 * Onboarding did appear block. Called just once when the onboarding did appear.
 */
@property (nonatomic, copy, nullable) BFOnboardingDidAppearBlock didAppearBlock;
/**
 * Onboarding completition block. Called when user finishes the onboarding process.
 */
@property (nonatomic, copy, nullable) BFOnboardingCompletionBlock completionBlock;
/**
 * Onboarding effect block. Called when user scrolls in the page view controller.
 */
@property (nonatomic, copy, nullable) BFOnboardingEffectBlock effectBlock;
/**
 * Onboarding skip block. Called when user skips the onboarding process.
 */
@property (nonatomic, copy, nullable) BFOnboardingSkipBlock skipBlock;
/**
 * Onboarding after login block. Called when user skips or finishes the onboarding process.
 * The block is executed during the prepareForSegue method.
 */
@property (nonatomic, copy, nullable) BFOnboardingAfterLoginBlock afterLoginBlock;

@end

NS_ASSUME_NONNULL_END
