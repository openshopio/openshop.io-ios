//
//  BFOpenShopOnboardingViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOpenShopOnboardingViewController.h"
#import "BFAppSessionInfo.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "BFOnboardingLoginContentViewController.h"
#import "BFOnboardingLanguageContentViewController.h"
#import "BFTabBarController.h"
#import "BFAppDelegate.h"


/**
 * Storyboard tab bar segue identifier.
 */
static NSString *const tabBarSegueIdentifier = @"tabBarSegue";


@interface BFOpenShopOnboardingViewController ()

@end

@implementation BFOpenShopOnboardingViewController


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
    self.viewControllers = @[
                             [self BFN_mainStoryboardClassInstanceWithClass:[BFOnboardingLanguageContentViewController class]],
                             [self BFN_mainStoryboardClassInstanceWithClass:[BFOnboardingLoginContentViewController class]]
                             ];
    // filter out view controllers that should display just on first launch
    if(![[BFAppSessionInfo sharedInfo]firstLaunch]) {
        self.viewControllers = [self.viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstLaunch = false"]];
    }
    // assign delegates
    [self.viewControllers makeObjectsPerformSelector:@selector(setDelegate:) withObject:self];
    // assign controller
    [self.viewControllers makeObjectsPerformSelector:@selector(setOnboardingController:) withObject:self];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // properties required to set up embeded page view controller
    self.pageControlHidden = [self.viewControllers count] <= 1;
    self.swipingEnabled = false;
    
    __weak __typeof(self) weakSelf = self;
    // onboarding skip
    self.skipBlock = ^(NSArray *controllers, NSInteger current) {
        // tab bar controller
        [weakSelf performSegueWithIdentifier:tabBarSegueIdentifier sender:weakSelf];
    };
    // onboarding finish
    self.completionBlock = ^(BOOL skipped) {
        [weakSelf performSegueWithIdentifier:tabBarSegueIdentifier sender:weakSelf];
    };
    // after login block
    self.afterLoginBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ui elements properties
    self.dimsBackground = true;
    self.blursBackground = false;
    self.allowsSkip = true;
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:tabBarSegueIdentifier]) {

    }
    // call to superclass to perform after login block
    [super prepareForSegue:segue sender:sender];
}


@end
