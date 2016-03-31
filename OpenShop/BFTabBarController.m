//
//  BFTabBarController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTabBarController.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"
#import "BFCartViewController.h"
#import "User.h"
#import "BFOpenShopOnboardingViewController.h"
#import "UITabBarItem+CustomBadge.h"
#import "BFViewControllerPushAnimator.h"
#import "BFViewControllerPopAnimator.h"
#import "BFAPIManager.h"
#import "BFDataResponseCartInfo.h"
#import "BFCart.h"
#import "ShoppingCart.h"

/**
 * Storyboard onboarding segue identifier.
 */
static NSString *const onboardingSegueIdentifier = @"onboardingSegue";
/**
 * Tab Bar Item vertical offset between title and image.
 */
static CGFloat const tabBarTitleVerticalOffset = 2;


@implementation BFTabBarController


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
    // properties
    self.delegate = self;
    // onboarding skip block
    __weak __typeof__(self) weakSelf = self;
    self.skipBlock = ^(NSArray *controllers, NSInteger current) {
        // return back
        [weakSelf.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    };
    // cart badge change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingCartBadgeValue) name:BFCartBadgeValueDidChangeNotification object:nil];
    
    // set initial shopping cart badge value
    [[ShoppingCart sharedCart] synchronizeCart];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view updateConstraints];
 }

#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, tabBarTitleVerticalOffset)];
}


#pragma mark - Tab Bar Selection

- (void)setSelectedItem:(BFTabBarItem)item withPopToRootViewController:(BOOL)pop animated:(BOOL)animated {
    if(pop) {
        [self popToRootViewControllerItem:item];
    }
    if (animated) {
#warning TODO: insert code for Navigation controllers transition animation
        [super setSelectedIndex:item];
    }
    else {
        [super setSelectedIndex:item];
    }
    
}

- (void)setSelectedItem:(BFTabBarItem)item withPopToRootViewController:(BOOL)pop {
    [self setSelectedItem:item withPopToRootViewController:YES animated:NO];
}

- (void)setSelectedItem:(BFTabBarItem)item animated:(BOOL)animated {
    [self setSelectedItem:item withPopToRootViewController:NO animated:YES];
}

- (void)popToRootViewControllerItem:(BFTabBarItem)item {
    UINavigationController *navController = (UINavigationController *)[self.viewControllers objectAtIndex:item];
    [navController popToRootViewControllerAnimated:NO];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // shopping cart selected and user is not logged in
    if([tabBarController.viewControllers indexOfObject:viewController] == BFTabBarItemShoppingCart && ![User isLoggedIn]) {
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(tabBarController) weakTabBarController = tabBarController;
        // after login select shopping cart tab
        self.afterLoginBlock = ^(UIViewController *viewController, BOOL skipped) {
            // dismiss
            [weakTabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            [weakTabBarController setSelectedIndex:(skipped ? weakSelf.selectedIndex : BFTabBarItemShoppingCart)];
        };
        // show onboarding view
        [self performSegueWithIdentifier:onboardingSegueIdentifier sender:self];
        return false;
    }
    return true;
}


#pragma mark - UITabBarItem Badge

- (void)setTabBarItem:(BFTabBarItem)tabBarItem badgeValue:(NSNumber *)badgeValue {
    if(tabBarItem < self.viewControllers.count) {
        UIViewController *tabBarItemController = [self.viewControllers objectAtIndex:tabBarItem];
        [tabBarItemController.tabBarItem setMyAppCustomBadgeValue:([badgeValue isEqualToNumber:@(0)] || ![User isLoggedIn]) ? nil : [NSString stringWithFormat:@"%@", badgeValue]];
    }
}

- (void)updateShoppingCartBadgeValue {
    NSNumber *badgeValue = [[ShoppingCart sharedCart] productCount];
    [self setTabBarItem:BFTabBarItemShoppingCart badgeValue:badgeValue ?: @(0)];
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // onboarding controller
    if ([[segue identifier] isEqualToString:onboardingSegueIdentifier]) {
        BFOpenShopOnboardingViewController *onboardingController = (BFOpenShopOnboardingViewController *)segue.destinationViewController;
        // apply after login block
        if(self.afterLoginBlock) {
            onboardingController.afterLoginBlock = self.afterLoginBlock;
            self.afterLoginBlock = nil;
        }
        // apply completion block
        if(self.completionBlock) {
            onboardingController.completionBlock = self.completionBlock;
            self.completionBlock = nil;
        }
        // apply did appear block
        if(self.didAppearBlock) {
            onboardingController.didAppearBlock = self.didAppearBlock;
            self.didAppearBlock = nil;
        }
        // apply skip block
        if(self.skipBlock) {
            onboardingController.skipBlock = self.skipBlock;
        }
        // custom transition
        onboardingController.transitioningDelegate = self;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    // push animation
    BFViewControllerPushAnimator *pushAnimator = [[BFViewControllerPushAnimator alloc] init];
    pushAnimator.modalPresentation = true;
    return pushAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    // pop animation
    BFViewControllerPopAnimator *popAnimator = [[BFViewControllerPopAnimator alloc] init];
    popAnimator.modalPresentation = true;
    return popAnimator;
}


#pragma mark - Status Bar Style

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}




@end
