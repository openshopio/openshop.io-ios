//
//  BFPushNotificationService.m
//  OpenShop
//
//  Created by Petr Škorňok on 11.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFPushNotificationService.h"
#import "UIAlertController+BFShowable.h"
#import "BFPushNotificationHandler.h"
#import "BFAppPreferences.h"

@implementation BFPushNotificationService

/*
 * Handling the case when the app was launched through the notification.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        NSDictionary *dictionary = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        DDLogDebug(@"Launch with notification dictionary: %@", dictionary);
        [BFPushNotificationHandler handleRemoteNotificationWithUserInfo:dictionary];
    }

    return YES;
}

/*
 * Handling the case when the app was launched through the notification.
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *apnsID = [[BFAppPreferences sharedPreferences] APNIdentification];
    if (!apnsID) {
        DDLogDebug(@"APNS ID not set, creating a new one");
        apnsID = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[BFAppPreferences sharedPreferences] setAPNIdentification:apnsID];
    }

    [BFPushNotificationHandler registerDeviceWithApnsID:apnsID];
    DDLogDebug(@"My token is: %@", apnsID);
}

/*
 * Failed to register for remote notifications.
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    // Application fail to register for remote notifications
    [[BFAppPreferences sharedPreferences] setAPNIdentification:nil];
    DDLogDebug(@"APNS register error: %@",[error localizedDescription]);
}

/*
 * Handling the case when the app was running and received remote notification.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DDLogDebug(@"Received remote notification with user info: %@", userInfo);
    
    NSString *message = userInfo[@"aps"][@"alert"];
    NSString *title = userInfo[@"custom"][@"alert"];
    
    if (objc_getClass("UIAlertController") && application.applicationState == UIApplicationStateActive && [message length] > 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *hideAction = [UIAlertAction actionWithTitle:BFLocalizedString(kTranslationHide, @"Hide")
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];
        UIAlertAction *showAction = [UIAlertAction actionWithTitle:BFLocalizedString(kTranslationBrowseHere, @"Browse here")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [BFPushNotificationHandler handleRemoteNotificationWithUserInfo:userInfo];
                                                           }];
        [alertController addAction:hideAction];
        [alertController addAction:showAction];
        [alertController setPreferredAction:showAction];

        [alertController show];
    }
    else {
        [BFPushNotificationHandler handleRemoteNotificationWithUserInfo:userInfo];
        
        // Google Analytics
//        NSString *action = @"OPENED_BY_NOTIFICATION";
//        NSString *label = [NSString stringWithFormat:@"OPENED_BY_NOTIFICATION with link: %@", userInfo[@"link"]];
//        [[BFNDataManager sharedManager] sendEventWithCategory:nil action:action label:label];
    }
}

@end
