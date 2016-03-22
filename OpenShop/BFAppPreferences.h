//
//  BFAppPreferences.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAppPreferences` provides information of application preferences.
 * It is intended to be modified by user and to save important info of
 * his app customization requests.
 */
@interface BFAppPreferences : NSObject <NSCoding>

/**
 * Selected shop identification.
 */
@property (nonatomic, strong, nullable) NSNumber *selectedShop;
/**
 * Selected language identification.
 */
@property (nonatomic, strong, nullable) NSNumber *selectedLanguage;
/**
 * Selected organization identification.
 */
@property (nonatomic, strong, nullable) NSNumber *selectedOrganization;
/**
 * Apple push notification service device identification.
 */
@property (nonatomic, strong, nullable) NSString *APNIdentification;
/**
 * Preferred products view type (single item or collection).
 */
@property (nonatomic, strong, nullable) NSNumber *preferredViewType;
/**
 * Preferred products sort type (by popularity, price, newest).
 */
@property (nonatomic, strong, nullable) NSNumber *preferredSortType;
/**
 * Preferred products menu category (men, women).
 */
@property (nonatomic, strong, nullable) NSNumber *preferredMenuCategory;
/**
 * Selected language code (ISO 639-1).
 */
@property (nonatomic, copy) NSString *selectedLanguageCode;

/**
 * Class method to access the static preferences instance.
 *
 * @return Singleton instance of the `BFAppPreferences` class.
 */
+ (BFAppPreferences *)sharedPreferences;

/**
 * Resets all preferences to their default values.
 */
- (void)resetPreferences;


@end

NS_ASSUME_NONNULL_END
