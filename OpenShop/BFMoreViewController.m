//
//  BFMoreViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFMoreViewController.h"
#import "BFUserProfileItemsTableViewCellExtension.h"
#import "BFInfoSettingsItemsTableViewCellExtension.h"
#import "BFOpenShopOnboardingViewController.h"
#import "BFAPIManager.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "BFInfoPageViewController.h"
#import "BFSettingsViewController.h"
#import "BFBranchViewController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "PersistentStorage.h"
#import "BFBranch.h"
#import "BFBranchTransport.h"
#import "BFTabBarController.h"
#import "BFUserDetailsViewController.h"
#import "User.h"
#import "BFError.h"
#import "BFWishlistViewController.h"
#import "UIWindow+BFOverlays.h"
#import "BFOrdersViewController.h"

/**
 * Storyboard onboarding segue identifier.
 */
static NSString *const onboardingSegueIdentifier  = @"onboardingSegue";
/**
 * Storyboard info page segue identifier.
 */
static NSString *const infoPageSegueIdentifier    = @"infoPageSegue";
/**
 * Storyboard settings segue identifier.
 */
static NSString *const settingsSegueIdentifier    = @"settingsSegue";
/**
 * Storyboard user details segue identifier.
 */
static NSString *const userDetailsSegueIdentifier = @"userDetailsSegue";
/**
 * Storyboard wishlist segue identifier.
 */
static NSString *const wishlistSegueIdentifier    = @"wishlistSegue";
/**
 * Storyboard orders segue identifier.
 */
static NSString *const ordersSegueIdentifier      = @"ordersSegue";
/**
 * The data source refreshing delay. Used to finish the view controller transition before the data refresh.
 */
static CGFloat const dataSourceRefreshDelay       = 0.5;



@interface BFMoreViewController ()

/**
 * User profile items table view cell extension.
 */
@property (nonatomic, strong) BFUserProfileItemsTableViewCellExtension *userProfileItemsExtension;
/**
 * Info settings items table view cell extension.
 */
@property (nonatomic, strong) BFInfoSettingsItemsTableViewCellExtension *infoSettingsItemsExtension;

@end


@implementation BFMoreViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationOpenShop, @"OpenShop") uppercaseString];
    
    // setup table view cell extensiosn
    [self setupExtensions];
    
    // fetch data
    [self reloadDataFromNetwork];
    
    // user state change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChanged) name:BFUserDidChangeNotification object:nil];
    // language changed notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChangedAction) name:BFLanguageDidChangeNotification object:nil];
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // user profile items
    _userProfileItemsExtension = [[BFUserProfileItemsTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_userProfileItemsExtension];
    
    // info and settings items
    _infoSettingsItemsExtension = [[BFInfoSettingsItemsTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_infoSettingsItemsExtension];
}

#pragma mark - Language changed notification

- (void)shopChangedAction {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // fetch info pages
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findInfoPagesWithCompletionBlock:^(NSArray *records, id customResponse, NSError *error) {
        // error results
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            [customError showAlertFromSender:weakSelf];
        }
        else {
            if(records.count) {
                // set info pages
                weakSelf.infoSettingsItemsExtension.infoPages = records;
                // reload the extension
                [weakSelf reloadExtensions:@[weakSelf.infoSettingsItemsExtension] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }];
}


#pragma mark - User State Management

- (void)userStateChanged {
    // refresh data sources
    if(self.userProfileItemsExtension && self.infoSettingsItemsExtension) {
        // begin updates to inform the tableView that we are changing the data source
        [self.tableView beginUpdates];
        [self.userProfileItemsExtension refreshDataSource];
        [self.infoSettingsItemsExtension refreshDataSource];
        
        // refresh data source after a delay so that the navigation transition
        // has time to finish
        __weak __typeof__(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dataSourceRefreshDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf refreshDataSource];
            [strongSelf.tableView endUpdates];
        });
    }
    
    // fetch data
    if([User isLoggedIn]) {
        [self reloadDataFromNetwork];
    }
}

- (void)refreshDataSource {
    [self reloadExtensions:@[self.userProfileItemsExtension, self.infoSettingsItemsExtension] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return false;
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFOpenShopOnboardingViewController class]) {
        BFTabBarController *tabBarController = (BFTabBarController *)self.tabBarController;
        if(tabBarController) {
            // onboarding skip block
            __weak __typeof__(tabBarController) weakTabBarController = tabBarController;
            // onboarding completion block
            tabBarController.completionBlock = ^(BOOL skipped) {
                // return back
                [weakTabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            };
            
            // present the onboarding view from the tab bar controller
            [tabBarController performSegueWithIdentifier:onboardingSegueIdentifier sender:self];
        }
    }
    else if(viewController == [BFInfoPageViewController class]) {
        // present the info page view controller
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:infoPageSegueIdentifier sender:self];
    }
    else if(viewController == [BFSettingsViewController class]) {
        // present the settings view controller
        [self performSegueWithIdentifier:settingsSegueIdentifier sender:self];
    }
    else if(viewController == [BFWishlistViewController class]) {
        // present the settings view controller
        [self performSegueWithIdentifier:wishlistSegueIdentifier sender:self];
    }
    else if(viewController == [BFBranchViewController class]) {
        // present branches view controller
        [self presentBranchesViewController];
    }
    else if(viewController == [BFUserDetailsViewController class]) {
        // present user details view controller
        [self presentUserDetailsViewController];
    }
    else if(viewController == [BFOrdersViewController class]) {
        // present orders view controller
        [self performSegueWithIdentifier:ordersSegueIdentifier sender:self];
    }
}

- (void)presentBranchesViewController {
    // activity indicator
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationLoading, @"Loading") animated:YES];
    // branches fetching
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findBranchesWithCompletionBlock:^(NSArray *records, id customResponse, NSError *error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        __weak __typeof__(strongSelf) weakSelf = strongSelf;
        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
            // error handling
            if(error) {
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
            }
            else {
                // display branches
                if(records.count) {
                    BFBranchViewController *branchController = (BFBranchViewController *)[weakSelf BFN_mainStoryboardClassInstanceWithClass:[BFBranchViewController class]];
                    branchController.branches = records;
                    // present form sheet
                    [branchController presentFormSheetWithOptionsHandler:nil animated:YES fromSender:self];
                }
                else {
                    BFError *customError = [BFError errorWithCode:BFErrorCodeNoData];
                    [customError showAlertFromSender:weakSelf];
                }
            }
        } animated:YES];
    }];
}

- (void)presentUserDetailsViewController {
    // activity indicator
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationLoading, @"Loading") animated:YES];
    // user details fetching
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findUserDetailsWithCompletionBlock:^(id response, NSError *error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        __weak __typeof__(strongSelf) weakSelf = strongSelf;
        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
            // error handling
            if(error) {
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
            }
            else {
                NSError *updateError;
                // parse and save received response data
                if([[User sharedUser]updateWithJSONDictionary:response error:&updateError]) {
                    [[User sharedUser]saveUser];
                    
                    // present user details
                    [self performSegueWithIdentifier:userDetailsSegueIdentifier sender:self];
                }
                else {
                    BFError *customError = [BFError errorWithError:updateError];
                    [customError showAlertFromSender:weakSelf];
                }
            }
        } animated:YES];
    }];
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // info page view controller
    if ([[segue identifier] isEqualToString:infoPageSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if([[navController.viewControllers firstObject]isKindOfClass:[BFInfoPageViewController class]]) {
                BFInfoPageViewController *infoPageController = (BFInfoPageViewController *)[navController.viewControllers firstObject];
                [self applySegueParameters:infoPageController];
            }
        }
    }
    // settings view controller
    else if ([[segue identifier] isEqualToString:settingsSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFSettingsViewController class]]) {
            BFSettingsViewController *settingsController = (BFSettingsViewController *)segue.destinationViewController;
            [self applySegueParameters:settingsController];
        }
    }
    // user details view controller
    else if ([[segue identifier] isEqualToString:userDetailsSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFUserDetailsViewController class]]) {
            BFUserDetailsViewController *userDetailsController = (BFUserDetailsViewController *)segue.destinationViewController;
            [self applySegueParameters:userDetailsController];
        }
    }
    
}


#pragma mark - RETableViewManager Delegate Methods

- (BOOL)respondsToSelector:(SEL)selector {
    if (selector == @selector(tableView:estimatedHeightForFooterInSection:)) {
        return false;
    }
    // for any other selector just use the default implementation
    return [super respondsToSelector:selector];
}


@end
