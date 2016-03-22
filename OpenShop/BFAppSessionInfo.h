//
//  BFAppSessionInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAppSessionInfo` provides information of current application install
 * and the device information where the application is running.
 */
@interface BFAppSessionInfo : NSObject <NSCoding>

/**
 * Class method to access the static app session info instance.
 *
 * @return Singleton instance of the `BFAppSessionInfo` class.
 */
+ (BFAppSessionInfo *)sharedInfo;
/**
 * Flag indicating the application first launch.
 *
 * @return The first launch flag.
 */
@property (nonatomic, assign) BOOL firstLaunch;
/**
 * Flag indicating if the permissions for notification were asked.
 *
 * @return Permissions were asked.
 */
@property (nonatomic, assign) BOOL askedForPushNotificationsPermissions;

/**
 * Application display name.
 *
 * @return Application name.
 */
+ (nullable NSString *)appName;
/**
 * Application version number description.
 *
 * @return Application version number.
 */
+ (nullable NSString *)appVersion;
/**
 * Application build number description.
 *
 * @return Application build number.
 */
+ (nullable NSString *)build;
/**
 * Application version with build number.
 *
 * @return Application version with build number.
 */
+ (nullable NSString *)versionBuild;
/**
 * Unique device identification number in a readable format.
 *
 * @return Unique device token.
 */
+ (nullable NSString *)deviceToken;
/**
 * Current device primary language code.
 *
 * @return Current language code.
 */
+ (nullable NSString *)currentLanguage;

@end

NS_ASSUME_NONNULL_END
