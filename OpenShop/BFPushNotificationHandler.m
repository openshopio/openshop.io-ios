//
//  BFPushNotificationHandler.m
//  OpenShop
//
//  Created by Petr Škorňok on 13.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFPushNotificationHandler.h"
#import "BFKeystore.h"
#import "BFShop.h"
#import "BFAppStructure.h"
#import "BFAPIManager.h"
#import "BFAppPreferences.h"
#import "BFViewController+BFChangeShop.h"
#import "UIViewController+BFUtils.h"
#import "BFPushNotificationViewController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "UIWindow+BFOverlays.h"
#import "BFAppSessionInfo.h"

/**
 * Storyboard unwind to offers segue identifier.
 */
static NSString *const unwindToOffersSegueIdentifier = @"unwindToOffers";

@implementation BFPushNotificationHandler

+ (void)tryToRegisterForRemoteNotifications {
    if (![[BFAppSessionInfo sharedInfo]askedForPushNotificationsPermissions]) {
        [BFPushNotificationHandler presentPushNotificationController];
    }
}

+ (BOOL)pushNotificationsEnabled {
    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    return (types & UIUserNotificationTypeAlert);
}

+ (void)askForPermissions
{
    [[BFAppSessionInfo sharedInfo]setAskedForPushNotificationsPermissions:YES];

    // iOS 8+ Notifications
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationType)(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void)registerDeviceWithApnsID:(NSString *)apnsID {
    if (!apnsID) {
        DDLogWarn(@"Couldn't register device token for remote notifications because apnsID is not available.");
    }
    else if (![[BFAppPreferences sharedPreferences] selectedShop]) {
        DDLogWarn(@"Couldn't register device token for remote notifications because shop has not been selected yet.");
    }
    else {
        BFAPIRequestDeviceInfo *deviceInfo = [[BFAPIRequestDeviceInfo alloc] initWithPlatform:@"ios"
                                                                                  deviceToken:apnsID];
        [[BFAPIManager sharedManager] registerDeviceWithInfo:deviceInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            if (error) {
                DDLogDebug(@"Couldn't register device token for remote notifications");
            }
            else {
                DDLogDebug(@"Successfully registered for remote notifications.");
            }
        }];
    }
}

#pragma mark - Handling APNS notifications

+ (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)userInfo
{
    NSString *link = userInfo[@"link"];
    
    // is link URL?
    NSURL *candidateURL = [NSURL URLWithString:link];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        [[UIApplication sharedApplication] openURL:candidateURL];
        [BFPushNotificationHandler handleRemoteNotificationWithURL:candidateURL];
    }
    else {
        [BFPushNotificationHandler handleRemoteNotificationWithBannerString:link userInfo:userInfo];
    }
}

+ (void)handleRemoteNotificationWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)handleRemoteNotificationWithTargetShop:(NSNumber *)shopLanguageCode targetType:(BFLinkType)targetType targetID:(NSNumber *)targetID userInfo:(NSDictionary *)userInfo
{
    NSString *name = userInfo[@"title"];
    
#warning TODO refaktorovat spolu s BFBannerTableViewCellExtension didSelectRowAtIndex: nejlepe do BFViewController+BFChangeShop
    switch (targetType) {
        case BFLinkTypeDetail: {
            //[self.tableViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{segueParameterProductDetailID : @([targetID integerValue])}];
            break;
        }
        case BFLinkTypeList: {
            //[self.tableViewController performSegueWithViewController:[BFProductsViewController class] params:@{segueParameterProductCategoryID : @([targetID integerValue])}];
            break;
        }
        default:
            break;
    }

    NSNumber *selectedShop = [[BFAppPreferences sharedPreferences] selectedShop];
    UIViewController *currentViewController = [UIViewController currentViewController];

    // it isn't necessary to change shop
    if (selectedShop && [shopLanguageCode isEqualToNumber:selectedShop]) {
        if ([currentViewController isKindOfClass:[BFViewController class]]) {
            BFViewController *currentBFViewController = (BFViewController *)currentViewController;
            [currentViewController performSegueWithIdentifier:unwindToOffersSegueIdentifier sender:self];
        }
    }
    // change shop
    else {
        if ([currentViewController isKindOfClass:[BFViewController class]]) {
            BFViewController *currentBFViewController = (BFViewController *)currentViewController;
            [currentBFViewController selectShop:shopLanguageCode completion:^{

            }];
        }
        
    }
    
//    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//    f.numberStyle = NSNumberFormatterDecimalStyle;
//    NSNumber *targetShopID = [f numberFromString:targetShop];
//    
//    // change shop if necessary
//    if ([targetShopID intValue] != [[[BFNDataManager sharedManager] selectedShopID] intValue]) {
//        [MRProgressOverlayView showOverlayAddedTo:self.tabBarController.navigationController.topViewController.view title:NSLocalizedString(@"Měním obchod", @"Měním obchod") mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
//        [[BFNDataManager sharedManager] selectShopWithID:targetShopID success:^{
//            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
//            [MRProgressOverlayView dismissAllOverlaysForView:self.tabBarController.navigationController.topViewController.view animated:YES];
//
//            BFNAppDelegate *appDelegate = (BFNAppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.tabBarController reloadInputViews];
//
//            [self.tabBarController setSelectedViewController:self.offersNavigationController];
//            [self.offersNavigationController popToRootViewControllerAnimated:NO];//make sure we're at the top level More
//            [self.offersNavigationController pushViewController:viewControllerToPush animated:YES];
//
//        } failure:^(NSError *error) {
//            [MRProgressOverlayView dismissAllOverlaysForView:self.tabBarController.navigationController.topViewController.view animated:YES completion:^{
//            }];
//        }];
//    }
//    else {
//        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
//        [self.tabBarController setSelectedViewController:self.offersNavigationController];
//        [self.offersNavigationController popToRootViewControllerAnimated:NO];//make sure we're at the top level More
//        [self.offersNavigationController pushViewController:viewControllerToPush animated:YES];
//    }
}

+ (void)handleRemoteNotificationWithBannerString:(NSString *)bannerString userInfo:(NSDictionary *)userInfo
{
//    NSArray *componentArray = [bannerString componentsSeparatedByString:@":"];
//    if (componentArray.count != 3) {
//        return;
//    }
//
//    NSString *targetShop = componentArray[0];
//    NSString *targetType = componentArray[1];
//    NSString *targetID = componentArray[2];
//    
//    [BFPushNotificationHandler handleRemoteNotificationWithTargetShop:targetShop targetType:targetType targetID:targetID userInfo:userInfo];
}

#pragma mark - Present Form Sheet

+ (void)presentPushNotificationController {
    BFPushNotificationViewController *pushNotificationController = (BFPushNotificationViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFPushNotificationViewController class]];
    // present form sheet
    [pushNotificationController presentFormSheetWithOptionsHandler:^(MZFormSheetPresentationViewController *formSheetController) {
        formSheetController.allowDismissByPanningPresentedView = YES;
        formSheetController.contentViewCornerRadius = 5.0;
    } animated:YES fromSender:[[UIApplication sharedApplication] keyWindow].rootViewController];
}


@end
