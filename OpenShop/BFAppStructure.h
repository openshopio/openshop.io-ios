//
//  BFAppStructure.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN


/**
 * Shop languages.
 */
typedef NS_ENUM(NSInteger, BFLanguage) {
    BFLanguageCzech,
    BFLanguageSlovak,
};

/**
 * Shops identification.
 */
typedef NS_ENUM(NSInteger, BFShopIdentification) {
    BFShopIdentificationOpenShop = 17
};

/**
 * Menu categories.
 */
typedef NS_ENUM(NSInteger, BFMenuCategory) {
    BFMenuCategoryNone,
    BFMenuCategoryWomen,
    BFMenuCategoryMen,
};

/**
 * Static menu categories.
 */
typedef NS_ENUM(NSInteger, BFStaticMenuCategory) {
    BFStaticMenuCategoryPopular,
    BFStaticMenuCategorySale
};

/**
 * Sort types.
 */
typedef NS_ENUM(NSInteger, BFSortType) {
    BFSortTypePopularity = 0,
    BFSortTypeNewest,
    BFSortTypeHighestPrice,
    BFSortTypeLowestPrice,
};

/**
 * Filter types.
 */
typedef NS_ENUM(NSInteger, BFNFilterType) {
    BFNProductFilterTypeColor = 0,
    BFNProductFilterTypeSize,
    BFNProductFilterTypeBrand,
    BFNProductFilterTypePriceRange
};

/**
 * Products view types.
 */
typedef NS_ENUM(NSInteger, BFViewType) {
    BFViewTypeSingleItem = 0,
    BFViewTypeCollection
};

/**
 * App link types.
 */
typedef NS_ENUM(NSInteger, BFLinkType) {
    BFLinkTypeDetail = 0,
    BFLinkTypeList
};

/**
 * User profile item types.
 */
typedef NS_ENUM(NSInteger, BFUserProfileItem) {
    BFUserProfileItemOrders = 0,
    BFUserProfileItemMyProfile,
    BFUserProfileItemMyWishlist,
    BFUserProfileItemLogin
};

/**
 * Info settings item types.
 */
typedef NS_ENUM(NSInteger, BFInfoSettingsItem) {
    BFInfoSettingsItemBranches = 0,
    BFInfoSettingsItemCountry
};

/**
 * Shipping and payment item types.
 */
typedef NS_ENUM(NSInteger, BFShippingAndPaymentRow) {
    BFShippingAndPaymentRowShipping,
    BFShippingAndPaymentRowPayment
};

/**
 * Shipping and payment item types.
 */
typedef NS_ENUM(NSInteger, BFShippingAndPaymentItem) {
    BFShippingAndPaymentItemUnkown   = 0,
    BFShippingAndPaymentItemShipping,
    BFShippingAndPaymentItemPayment
};

/**
 * Address rows types.
 */
typedef NS_ENUM(NSInteger, BFAddressRow) {
    BFAddressRowName = 0,
    BFAddressRowEmail,
    BFAddressRowStreetHouseNumber,
    BFAddressRowCityPostalCode,
    BFAddressRowPhoneNumber
};

/**
 * Address item types.
 */
typedef NS_ENUM(NSInteger, BFAddressItem) {
    BFAddressItemUnkown = 0,
    BFAddressItemName   = 120,
    BFAddressItemEmail,
    BFAddressItemStreet,
    BFAddressItemHouseNumber,
    BFAddressItemCity,
    BFAddressItemPostalCode,
    BFAddressItemPhoneNumber
};

/**
 * Address item types.
 */
typedef NS_ENUM(NSInteger, BFNoteItem) {
    BFNoteItemNote = 0,
};

/**
 * Order summary item types.
 */
typedef NS_ENUM(NSInteger, BFOrderSummaryItem) {
    BFOrderSummaryItemTotal = 0,
};

/**
 * Order summary address rows types.
 */
typedef NS_ENUM(NSInteger, BFOrderSummaryAddressRow) {
    BFOrderSummaryAddressRowNamePhone = 0,
    BFOrderSummaryAddressRowStreetHouseEmail,
    BFOrderSummaryAddressRowZIPCity,
};

/**
 * Edit product in cart items.
 */
typedef NS_ENUM(NSInteger, BFEditCartProductItem) {
    BFEditCartProductItemColor = 0,
    BFEditCartProductItemSize,
    BFEditCartProductItemQuantity,
};

/**
 * Login items.
 */
typedef NS_ENUM(NSInteger, BFLoginItem) {
    BFLoginItemEmail = 130,
    BFLoginItemPassword
};

/**
 * Registration items.
 */
typedef NS_ENUM(NSInteger, BFRegistrationItem) {
    BFRegistrationItemEmail = 140,
    BFRegistrationItemPassword
};

/**
 * `BFAppStructure` provides information of application structure and structure items
 * translated names. Translated names are required during the API communication or
 * to display the items in a human readable format. It also contains structure enum
 * mappings to their corresponding elements.
 */
@interface BFAppStructure : NSObject


#pragma mark - Translations (Display Names)

/**
 * Translates menu category to its display name.
 *
 * @param menuCategory The menu category.
 * @return The menu category display name.
 */
+ (nullable NSString *)menuCategoryDisplayName:(BFMenuCategory)menuCategory;
/**
 * Translates static menu category to its display name.
 *
 * @param staticMenuCategory The static menu category.
 * @return The static menu category display name.
 */
+ (nullable NSString *)staticMenuCategoryDisplayName:(BFStaticMenuCategory)staticMenuCategory;
/**
 * Translates sort type to its display name.
 *
 * @param sortType The sort type.
 * @return The sort type display name.
 */
+ (nullable NSString *)sortTypeDisplayName:(BFSortType)sortType;
/**
 * Translates the language to its display name.
 *
 * @param language The language.
 * @return The language display name.
 */
+ (nullable NSString *)languageDisplayName:(BFLanguage)language;
/**
 * Translates the language to its country display name.
 *
 * @param language The language.
 * @return The language country display name.
 */
+ (nullable NSString *)languageCountryDisplayName:(BFLanguage)language;
/**
 * Translates user profile item to its display name.
 *
 * @param userProfileItem The user profile item.
 * @return The user profile item display name.
 */
+ (nullable NSString *)userProfileItemDisplayName:(BFUserProfileItem)userProfileItem;
/**
 * Translates info settings item to its display name.
 *
 * @param infoSettingsItem The info settings item.
 * @return The info settings item display name.
 */
+ (nullable NSString *)infoSettingsItemDisplayName:(BFInfoSettingsItem)infoSettingsItem;


#pragma mark - Translations (API Names)

/**
 * Translates static menu category to its API name.
 *
 * @param staticMenuCategory The static menu category.
 * @return The static menu category API name.
 */
+ (nullable NSString *)staticMenuCategoryAPIName:(BFStaticMenuCategory)staticMenuCategory;
/**
 * Translates sort type to its API name.
 *
 * @param sortType The sort type.
 * @return The sort type API name.
 */
+ (nullable NSString *)sortTypeAPIName:(BFSortType)sortType;
/**
 * Translates sort type API name to its enum equivalent.
 *
 * @param sortTypeAPIName The sort type API name.
 * @return The sort type enum equivalent.
 */
+ (BFSortType)sortTypeFromAPIName:(NSString *)sortTypeAPIName;
/**
 * Translates filter type API name to its enum equivalent.
 *
 * @param filterTypeAPIName The filter type API name.
 * @return The filter type enum equivalent.
 */
+ (nullable NSNumber *)filterTypeFromAPIName:(NSString *)filterTypeAPIName;
/**
 * Translates menu category to its API name.
 *
 * @param menuCategory The menu category.
 * @return The menu category API name.
 */
+ (nullable NSString *)menuCategoryAPIName:(BFMenuCategory)menuCategory;
/**
 * Translates link type API name to its enum equivalent.
 *
 * @param linkTypeAPIName The link type API name.
 * @return The link type enum equivalent or nil.
 */
+ (nullable NSNumber *)linkTypeFromAPIName:(NSString *)linkTypeAPIName;


#pragma mark - Translations

/**
 * Translates the language to its language code (ISO 639-1).
 *
 * @param language The language.
 * @return The language code.
 */
+ (nullable NSString *)languageCode:(BFLanguage)language;
/**
 * Translates the language code (ISO 639-1) to its corresponding `BFLanguage` enum type.
 *
 * @param languageCode The language code.
 * @return The language enum type wrapped in `NSNumber` instance.
 */
+ (nullable NSNumber *)languageWithCode:(NSString *)languageCode;
/**
 * Translates the shop identification to its universal analytics (UA) code.
 *
 * @param shopIdentification The shop identification.
 * @return The shop UA code.
 */
+ (nullable NSString *)shopUACode:(BFShopIdentification)shopIdentification;
/**
 * Translates static menu category to its icon.
 *
 * @param staticMenuCategory The static menu category.
 * @return The static menu category icon.
 */
+ (nullable UIImage *)staticMenuCategoryIcon:(BFStaticMenuCategory)staticMenuCategory;


#pragma mark - Address Items and Rows

/**
 * Translates 'BFAddressRow' to 'BFAddressItem'.
 *
 * @param row address row.
 * @return address first item.
 */
+ (nullable NSNumber *)addressItemFromRow:(BFAddressRow)row;
/**
 * Translates 'BFAddressItem' to 'BFAddressRow'.
 *
 * @param item address item.
 * @return address row.
 */
+ (nullable NSNumber *)addressRowFromItem:(BFAddressItem)item;

#pragma mark - Shipping & Payment Items and Rows
/**
 * Translates 'BFShippingAndPaymentRow' to 'BFShippingAndPaymentItem'.
 *
 * @param row shipping and payment row
 * @return shipping and payment first item
 */
+ (nullable NSNumber *)shippingPaymentItemFromRow:(BFShippingAndPaymentRow)row;
/**
 * Translates 'BFShippingAndPaymentItem' to 'BFShippingAndPaymentRow'.
 *
 * @param item shipping and payment item.
 * @return shipping and payment row.
 */
+ (nullable NSNumber *)shippingPaymentRowFromItem:(BFShippingAndPaymentItem)item;


@end

NS_ASSUME_NONNULL_END
