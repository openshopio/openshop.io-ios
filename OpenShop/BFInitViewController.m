//
//  BFInitViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFInitViewController.h"
#import "User.h"
#import "BFTabBarController.h"
#import "BFAppDelegate.h"

@interface BFInitViewController ()

@end

/**
 * Launch screen delay (miliseconds).
 */
static NSInteger const launchScreenDelay         = 1500;
/**
 * Launch image name component.
 */
static NSString *const launchImageNameComponent  = @"LaunchImage";
/**
 * Storyboard tab bar segue identifier.
 */
static NSString *const tabBarSegueIdentifier     = @"tabBarSegue";
/**
 * Storyboard onboarding segue identifier.
 */
static NSString *const onboardingSegueIdentifier = @"onboardingSegue";


@implementation BFInitViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup proper launch image
    self.launchImageView.image = [self launchImage];
}

- (void)viewDidAppear:(BOOL)animated {
    if(![User isLoggedIn]) {
        // login view controller
        [self performSegueWithIdentifier:onboardingSegueIdentifier sender:self afterDelay:launchScreenDelay];
    }
    else {
        // tab bar controller
        [self performSegueWithIdentifier:tabBarSegueIdentifier sender:self afterDelay:launchScreenDelay];
    }
    [super viewDidAppear:animated];
}


#pragma mark - Segue Management

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender afterDelay:(NSInteger)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_MSEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:identifier sender:sender];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // tab bar controller
    if ([[segue identifier] isEqualToString:tabBarSegueIdentifier]) {

    }
    // onboarding controller
    else if ([[segue identifier] isEqualToString:onboardingSegueIdentifier]) {
        
    }
}


#pragma mark - Launch Image

- (UIImage *)launchImage {
    NSArray *allImages = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil];
    
    for (NSString *imageName in allImages){
        // searching for launch image
        if (([imageName rangeOfString:@"~ipad"].location == NSNotFound || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) && [imageName rangeOfString:launchImageNameComponent].location != NSNotFound) {
            UIImage *image = [UIImage imageNamed:imageName];
            // check dimensions and scale
            if ([@(image.scale) isEqualToNumber:@([UIScreen mainScreen].scale)] && CGSizeEqualToSize(image.size, [UIScreen mainScreen].bounds.size)) {
                return image;
            }
        }
    }
    return nil;
}

@end
