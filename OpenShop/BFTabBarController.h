//
//  BFTabBarController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "BFOnboardingViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Tab bar items.
 */
typedef NS_ENUM(NSInteger, BFTabBarItem) {
    BFTabBarItemOffers = 0,
    BFTabBarItemCategories,
    BFTabBarItemShoppingCart,
    BFTabBarItemSearch,
    BFTabBarItemMore
};

/**
 * `BFTabBarController` is the `UITabBarController` subclass implementing the `UITabBarControllerDelegate`
 * methods. It also manages tab bar items badge values.
 */
@interface BFTabBarController : UITabBarController <BFCustomAppearance, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate>

/**
 * Sets tab bar item badge value.
 *
 * @param tabBarItem The tab bar item.
 * @param badgeValue The badge text value.
 */
- (void)setTabBarItem:(BFTabBarItem)tabBarItem badgeValue:(NSNumber *)badgeValue;

/**
 * Selects tab bar item with optional pop to the root view controller of the presented navigation controller and optional animation.
 *
 * @param tabBarItem The tab bar item.
 * @param pop The pop to the root view controller is performed if set.
 * @param animated Should animate selection.
 */
- (void)setSelectedItem:(BFTabBarItem)tabBarItem withPopToRootViewController:(BOOL)pop animated:(BOOL)animated;
/**
 * Selects tab bar item with optional pop to the root view controller of the presented navigation controller.
 *
 * @param tabBarItem The tab bar item.
 * @param pop The pop to the root view controller is performed if set.
 */
- (void)setSelectedItem:(BFTabBarItem)tabBarItem withPopToRootViewController:(BOOL)pop;
/**
 * Selects tab bar with optional animation.
 *
 * @param tabBarItem The tab bar item.
 * @param animated Should animate selection.
 */
- (void)setSelectedItem:(BFTabBarItem)tabBarItem animated:(BOOL)animated;
/**
 * Pops Item's navigation controller to root view controller.
 *
 * @param tabBarItem The tab bar item.
 */
- (void)popToRootViewControllerItem:(BFTabBarItem)tabBarItem;

/**
 * Onboarding after login block. Called when user skips or finishes the onboarding process.
 * The block is executed during the prepareForSegue method.
 */
@property (nonatomic, copy, nullable) BFOnboardingAfterLoginBlock afterLoginBlock;
/**
 * Onboarding completition block. Called when user finishes the onboarding process.
 */
@property (nonatomic, copy, nullable) BFOnboardingCompletionBlock completionBlock;
/**
 * Onboarding skip block. Called when user skips the onboarding process.
 */
@property (nonatomic, copy, nullable) BFOnboardingSkipBlock skipBlock;
/**
 * Onboarding did appear block. Called just once when the onboarding did appear.
 */
@property (nonatomic, copy, nullable) BFOnboardingDidAppearBlock didAppearBlock;


@end

NS_ASSUME_NONNULL_END


