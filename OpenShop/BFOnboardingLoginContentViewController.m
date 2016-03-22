//
//  BFOnboardingLoginContentViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingLoginContentViewController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "BFOnboardingLoginEmailViewController.h"
#import "BFOnboardingRegistrationViewController.h"
#import "BFOnboardingViewController.h"
#import "BFFacebookManager.h"
#import "BFAPIManager.h"
#import "User.h"
#import "UIWindow+BFOverlays.h"
#import "UIColor+BFColor.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

/**
 * Content height.
 */
static CGFloat const contentHeight = 260.0f;
/**
 * Content view fade out animation duration.
 */
static CGFloat const contentViewFadeOutDuration = 0.5f;
/**
 * Content view fade in animation duration.
 */
static CGFloat const contentViewFadeInDuration = 0.5f;

@interface BFOnboardingLoginContentViewController ()
    
@end

@implementation BFOnboardingLoginContentViewController


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
    self.contentHeight = contentHeight;
}


#pragma mark - BFOnboardingContentViewState Protocol

- (void)visibilityChangedWithPercentage:(NSInteger)percentage {
    
    
}


#pragma mark - Buttons Actions

- (IBAction)emailClicked:(id)sender {
    // email view controller instance
    BFOnboardingLoginEmailViewController *emailController = (BFOnboardingLoginEmailViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFOnboardingLoginEmailViewController class]];
    // present form sheet
    [self presentLoginFormSheetFromController:emailController];
}

- (IBAction)registerClicked:(id)sender {
    // registration view controller instance
    BFOnboardingRegistrationViewController *registrationController = (BFOnboardingRegistrationViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFOnboardingRegistrationViewController class]];
    // present form sheet
    [self presentLoginFormSheetFromController:registrationController];
}

- (void)presentLoginFormSheetFromController:(BFFormSheetViewController *)controller {
    // present form sheet
    [controller presentFormSheetWithSize:CGSizeMake(self.view.frame.size.width, contentHeight) optionsHandler:^(MZFormSheetPresentationViewController *formSheetController) {
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
        // disable default MZFormSheet background color
        formSheetController.presentationController.backgroundColor = [UIColor clearColor];
        
        // custom presentation options with handlers
        __weak __typeof__(self) weakSelf = self;
        formSheetController.presentationController.dismissalTransitionWillBeginCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [weakSelf setContentViewHidden:NO animated:YES];
        };
        
        formSheetController.presentationController.dismissalTransitionDidEndCompletionHandler = ^(UIViewController *presentedFSViewController, BOOL completed) {
            if ([User isLoggedIn]) {
                [weakSelf.delegate finishOnboarding];
            }
        };
        formSheetController.presentationController.presentationTransitionWillBeginCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [weakSelf setContentViewHidden:YES animated:YES];
        };
        formSheetController.presentationController.frameConfigurationHandler = ^(UIView *presentedView, CGRect currentFrame, BOOL isKeyboardVisible) {
            if (isKeyboardVisible) {
                weakSelf.onboardingController.containerDimView.backgroundColor = [UIColor BFN_darkerDimColor];
                return CGRectMake(currentFrame.origin.x,
                                  weakSelf.onboardingController.view.frame.size.height - currentFrame.size.height - weakSelf.onboardingController.containerBottomConstraint.constant,
                                  currentFrame.size.width,
                                  currentFrame.size.height);
            }
            else {
                weakSelf.onboardingController.containerDimView.backgroundColor = [UIColor BFN_dimColor];
                return CGRectMake(currentFrame.origin.x,
                                  weakSelf.onboardingController.view.frame.size.height - currentFrame.size.height,
                                  currentFrame.size.width,
                                  currentFrame.size.height);
            }
        };
    } animated:YES fromSender:self];
}

- (IBAction)facebookClicked:(id)sender {
    __weak __typeof__(self) weakSelf = self;
    [[BFFacebookManager sharedManager]logInFromViewController:self withCompletionBlock:^(NSDictionary *response, NSError *error) {
        __weak __typeof__(self) strongSelf = weakSelf;
        // facebook login error
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            [customError showAlertFromSender:strongSelf];
        }
        else {
            [strongSelf.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationLoggingIn, @"Logging in") animated:YES];
            
            // user info
            BFAPIRequestUserInfo *userInfo = [[BFAPIRequestUserInfo alloc]init];
            userInfo.facebookID = [response objectForKey:@"id"];
            userInfo.facebookAccessToken = [[FBSDKAccessToken currentAccessToken]tokenString];
            
            // facebook credentials verification
            __weak __typeof__(self) weakSelf = strongSelf;
            [[BFAPIManager sharedManager]verifyUserWithFacebookInfo:userInfo completionBlock:^(id response, NSError *error) {
                [weakSelf.view.window dismissAllOverlaysWithCompletion:^{
                    __weak __typeof__(self) strongSelf = weakSelf;
                    // credentials verification error
                    if(error) {
                        BFError *customError = [BFError errorWithCode:BFErrorCodeFacebookLogin];
                        [customError showAlertFromSender:strongSelf];
                    }
                    // finalize login
                    else {
                        BFError *loginError = [[BFAPIManager sharedManager]finishUserRequestWithResponse:(NSDictionary *)response];
                        if(loginError) {
                            [loginError showAlertFromSender:strongSelf];
                        }
                        else {
                            if([User isLoggedIn]) {
                                [strongSelf.delegate finishOnboarding];
                            }
                        }
                    }
                } animated:YES];
            }];
        }
    }];
    
}


#pragma mark - Form Sheet Presentation Helpers

- (void)setContentViewHidden:(BOOL)hidden animated:(BOOL)animated{
    if (animated) {
        // fade out
        if (hidden) {
            [UIView animateWithDuration:contentViewFadeOutDuration animations:^{
                [self setContentViewAlpha:0.0];
            } completion: ^(BOOL finished) {
                [self setContentViewHidden:finished];
            }];
        }
        // fade in
        else {
            [self setContentViewAlpha:0.0];
            [self setContentViewHidden:NO];
            [UIView animateWithDuration:contentViewFadeInDuration animations:^{
                [self setContentViewAlpha:1.0];
            }];
        }
    }
    else {
        [self setContentViewHidden:YES animated:NO];
    }
}

- (void)setContentViewAlpha:(CGFloat)alpha {
    self.emailButton.alpha = alpha;
    self.facebookButton.alpha = alpha;
    self.skipButton.alpha = alpha;
    self.registerButton.alpha = alpha;
    self.subheaderLabel.alpha = alpha;
    self.onboardingController.pageControlAlpha = alpha;
}

- (void)setContentViewHidden:(BOOL)hidden {
    self.emailButton.hidden = hidden;
    self.facebookButton.hidden = hidden;
    self.skipButton.hidden = hidden;
    self.registerButton.hidden = hidden;
    self.subheaderLabel.hidden = hidden;
    self.onboardingController.pageControlHidden = hidden;
}

@end
