//
//  BFOnboardingViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingViewController.h"
#import "BFOnboardingContentViewController.h"
#import "BFAppSessionInfo.h"
#import "User.h"
#import "NSArray+BFObjectFiltering.h"
#import "UIImageEffects.h"
#import "UIColor+BFColor.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"


/**
 * Onboarding page view controller segue storyboard identifier.
 */
static NSString *const pageControllerSegueIdentifier = @"pageControllerSegue";


@interface BFOnboardingViewController ()

/**
 * Currently presented view controller index in the datasource.
 */
@property (nonatomic, assign) NSUInteger currentPageIndex;

@end


@implementation BFOnboardingViewController


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
    self.viewControllers = @[];
    self.currentPageIndex = 0;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    // properties required to set up embedded page view controller
    self.swipingEnabled = true;
    self.pageControlHidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ui elements properties
    self.dimsBackground = false;
    self.blursBackground = false;
    self.allowsSkip = true;
    self.containerDimView.backgroundColor = [UIColor BFN_dimColor];
    
    // initial child container height
    BFOnboardingContentViewController *firstController = self.viewControllers.firstObject;
    [self updateContainerHeightWithController:firstController];
    
    // register for keyboard notifications
    [self addKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // execute did appear block just once
    if(self.didAppearBlock) {
        self.didAppearBlock(self);
        self.didAppearBlock = nil;
    }
}

#pragma mark - Properties Setters

- (void)setPageControlHidden:(BOOL)pageControlHidden {
    _pageControlHidden = pageControlHidden;
    self.pageViewController.pageControl.hidden = pageControlHidden;
}

- (void)setPageControlAlpha:(CGFloat)pageControlAlpha {
    _pageControlAlpha = pageControlAlpha;
    self.pageViewController.pageControl.alpha = pageControlAlpha;
}

- (void)setDimsBackground:(BOOL)dimsBackground {
    _dimsBackground = dimsBackground;
    self.dimView.hidden = !_dimsBackground;
}

- (void)setAllowsSkip:(BOOL)allowsSkip {
    _allowsSkip = allowsSkip;
    self.skipButton.hidden = !_allowsSkip;
}

- (void)setBlursBackground:(BOOL)blursBackground {
    _blursBackground = blursBackground;
    if(_blursBackground) {
        // iOS 8 <= effect view
        if([UIVisualEffectView class]) {
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            // add effect to an effect view
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
            effectView.frame = self.backgroundImageView.frame;
            [self.backgroundImageView addSubview:effectView];
        }
        // pre iOS 8 effect view
        else {
            self.backgroundImageView.image = [UIImageEffects imageByApplyingLightEffectToImage:self.backgroundImageView.image];
        }
    }
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString:pageControllerSegueIdentifier]) {
        self.pageViewController = (BFOnboardingPageViewController *) [segue destinationViewController];
        [self.pageViewController setupWithOnboardingController:self];
    }
    else {
        // after login block to customize upcoming content
        if(self.afterLoginBlock) {
            self.afterLoginBlock(segue.destinationViewController, ![User isLoggedIn]);
        }
    }
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [self.viewControllers indexOfObject:viewController];
    currentIndex--;
    if(currentIndex < 0) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [self.viewControllers indexOfObject:viewController];
    currentIndex++;
    if(currentIndex >= self.viewControllers.count) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:currentIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.viewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.currentPageIndex;
}


#pragma mark - BFOnboardingControllerDelegate

- (void)moveToNextPage {
    NSUInteger nextPageIndex = self.currentPageIndex + 1;
    
    if (nextPageIndex < self.viewControllers.count) {
        self.currentPageIndex = nextPageIndex;
        // update child container height according to the value
        // set in the onboarding controller
        BFOnboardingContentViewController *controller = self.viewControllers[nextPageIndex];
        [self updateContainerHeightWithController:controller];
        [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (void)moveToPrevPage {
    NSInteger prevPageIndex = self.currentPageIndex - 1;
    
    if (prevPageIndex >= 0) {
        self.currentPageIndex = prevPageIndex;
        // update child container height according to the value
        // set in the onboarding controller
        BFOnboardingContentViewController *controller = self.viewControllers[prevPageIndex];
        [self updateContainerHeightWithController:controller];
        [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (void)setCurrentPage:(NSUInteger)pageIndex {
    if (pageIndex < self.viewControllers.count) {
        self.currentPageIndex = pageIndex;
        [self.pageViewController setViewControllers:@[self.viewControllers[pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (IBAction)skipOnboarding:(id)sender {
    if(self.skipBlock) {
        self.skipBlock(self.viewControllers, self.currentPageIndex);
    }
}

- (void)finishOnboarding {
    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFUserDidChangeNotification];
    if(self.completionBlock) {
        self.completionBlock(false);
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //  the percent complete of the transition of the current page
    CGFloat percentage = fabs(scrollView.contentOffset.x - self.view.frame.size.width) / self.view.frame.size.width;
    
    // no progress
    if (percentage == 0.0f) {
        return;
    }
    
    BOOL movingForward = false;
    if(scrollView.contentOffset.x >= self.currentPageIndex * self.view.frame.size.width) {
        movingForward = true;
    }
    
    // out of bounds
    if((movingForward && self.currentPageIndex == self.viewControllers.count-1) || (!movingForward && self.currentPageIndex == 0)) {
        return;
    }
    
    // notify effect block with changes
    if(self.effectBlock) {
        self.effectBlock(self.pageViewController, self.viewControllers, self.currentPageIndex, movingForward ? self.currentPageIndex+1 : self.currentPageIndex-1, percentage);
    }
    
    // notify controllers with visibility changes
    BFOnboardingContentViewController *currentController = [self.viewControllers objectAtIndex:self.currentPageIndex];
    BFOnboardingContentViewController *upcomingController = [self.viewControllers objectAtIndex:movingForward ? self.currentPageIndex+1 : self.currentPageIndex-1];
    if([currentController respondsToSelector:@selector(visibilityChangedWithPercentage:)]) {
        [currentController visibilityChangedWithPercentage:1.0f - percentage];
    }
    if([upcomingController respondsToSelector:@selector(visibilityChangedWithPercentage:)]) {
        [upcomingController visibilityChangedWithPercentage:percentage];
    }
}

#pragma mark - Update Container Height

- (void)updateContainerHeightWithController:(BFOnboardingContentViewController *)controller {
    if (controller && controller.contentHeight) {
        self.containerHeightConstraint.constant = controller.contentHeight;
    }
}

#pragma mark - UIKeyboard Notifications

- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)willShowKeyboardNotification:(NSNotification *)notification {
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardBounds = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];

    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         self.containerBottomConstraint.constant = keyboardBounds.size.height;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)willHideKeyboardNotification:(NSNotification *)notification {
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         self.containerBottomConstraint.constant = 0;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
