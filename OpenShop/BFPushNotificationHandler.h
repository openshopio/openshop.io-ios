//
//  BFPushNotificationHandler.h
//  OpenShop
//
//  Created by Petr Škorňok on 13.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

@interface BFPushNotificationHandler : NSObject

/**
 * If the device is not registered for the remote notifications
 * present the BFPushNotificationViewController.
 */
+ (void)tryToRegisterForRemoteNotifications;
/**
 * Asks for permissions for push notifications.
 */
+ (void)askForPermissions;
/**
 * Registers device APNS ID on server.
 */
+ (void)registerDeviceWithApnsID:(nullable NSString *)apnsID;
/**
 * Handle remote notification if the userInfo dictionary is provided.
 */
+ (void)handleRemoteNotificationWithUserInfo:(nonnull NSDictionary *)userInfo;
/**
 * Handle remote notification if URL is provided.
 */
+ (void)handleRemoteNotificationWithURL:(nonnull NSURL *)url;
/**
 * Handle remote notification if targetShop, targetType and targetID are provided.
 */
+ (void)handleRemoteNotificationWithTargetShop:(nonnull NSNumber *)shopLanguageCode targetType:(BFLinkType)targetType targetID:(nonnull NSNumber *)targetID userInfo:(nullable NSDictionary *)userInfo;
/**
 * Handle remote notification banner string is provided.
 * Banner string format is specified as "targetShop:targetType:targetID" string.
 */
+ (void)handleRemoteNotificationWithBannerString:(nonnull NSString *)bannerString userInfo:(nullable NSDictionary *)userInfo;

@end
