//
//  BFOnboardingContentViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFViewController.h"

@class BFOnboardingViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFOnboardingControllerDelegate` protocol specifies methods to control currently presented
 * view controller and the onboarding process.
 */
@protocol BFOnboardingControllerDelegate <NSObject>
/**
 * Moves in the onboarding process forward presenting the next view controller. Presenting order
 * follows the view controllers datasource order.
 */
- (void)moveToNextPage;
/**
 * Moves in the onboarding process backward presenting the previous view controller. Presenting order
 * follows the view controllers datasource order.
 */
- (void)moveToPrevPage;
/**
 * Sets current view controller in the onboarding process. Specified page index corresponds to the
 * view controller in the datasource array at the page index.
 */
- (void)setCurrentPage:(NSUInteger)pagerIndex;
/**
 * Skips the onboarding process. Method is designed as IBAction to be directly connectable with sender.
 *
 * @param sender The skip request sender.
 */
- (IBAction)skipOnboarding:(id)sender;
/**
 * Finishes the onboarding process.
 */
- (void)finishOnboarding;

@end


/**
 * `BFOnboardingContentViewState` protocol specifies callbacks to notify view controllers
 * of their content view changes.
 */
@protocol BFOnboardingContentViewState <NSObject>

@optional

/**
 * Notifies view controller of its visibility state change.
 *
 * @param percentage The percentage of view controller's visibility.
 */
- (void)visibilityChangedWithPercentage:(NSInteger)percentage;

@end

/**
 * `BFOnboardingContentViewController` represents page view presented during the user onboarding process.
 * It is designed as an abstract template to be subclassed for further use. It contains all properties
 * to be maintained with onboarding management view controller.
 */
IB_DESIGNABLE
@interface BFOnboardingContentViewController : BFViewController <BFOnboardingContentViewState>

/**
 * Header text label.
 */
@property (nonatomic, weak, nullable) IBOutlet UILabel *headerLabel;
/**
 * Subheader text label.
 */
@property (nonatomic, weak, nullable) IBOutlet UILabel *subheaderLabel;
/**
 * Image view (logo).
 */
@property (nonatomic, weak, nullable) IBOutlet UIImageView *imageView;
/**
 * Onboarding process controller delegate.
 */
@property (nonatomic, weak, nullable) id<BFOnboardingControllerDelegate> delegate;
/**
 * Onboarding process controller.
 */
@property (nonatomic, weak, nullable) BFOnboardingViewController *onboardingController;
/**
 * Onboarding skip button.
 */
@property (nonatomic, weak) IBOutlet UIButton *skipButton;
/**
 * First launch flag. If YES, it displays the view controller just on first app launch.
 */
@property (nonatomic, assign) IBInspectable BOOL firstLaunch;
/**
 * Height of the current view.
 */
@property (nonatomic) CGFloat contentHeight;


@end

NS_ASSUME_NONNULL_END
