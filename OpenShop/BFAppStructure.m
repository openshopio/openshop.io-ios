//
//  BFAppStructure.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppStructure.h"

@implementation BFAppStructure


#pragma mark - Display Names Mapping

+ (NSDictionary *)menuCategoryDisplayNames {
    return @{@(BFMenuCategoryMen)    : BFLocalizedString(kTranslationMen, @"Men"),
             @(BFMenuCategoryWomen)    : BFLocalizedString(kTranslationWomen, @"Women"),
             @(BFMenuCategoryNone)    : @"",
             };
}

+ (NSDictionary *)staticMenuCategoryDisplayNames {
    return @{@(BFStaticMenuCategoryPopular) : BFLocalizedString(kTranslationPopular, @"Popular"),
             @(BFStaticMenuCategorySale)      : BFLocalizedString(kTranslationSale, @"Sale"),
             };
}

+ (NSDictionary *)sortTypeDisplayNames {
    return @{@(BFSortTypePopularity)   : BFLocalizedString(kTranslationSortByPopularity, @"Popularity"),
             @(BFSortTypeNewest)       : BFLocalizedString(kTranslationNewestFirst, @"Newest first"),
             @(BFSortTypeHighestPrice) : BFLocalizedString(kTranslationPricestFirst, @"Pricest first"),
             @(BFSortTypeLowestPrice)  : BFLocalizedString(kTranslationCheapestFirst, @"Cheapest first"),
             };
}

+ (NSDictionary *)userProfileItemDisplayNames {
    return @{@(BFUserProfileItemOrders)     : BFLocalizedString(kTranslationMyOrders, @"My orders"),
             @(BFUserProfileItemMyProfile)  : BFLocalizedString(kTranslationMyAccount, @"My account"),
             @(BFUserProfileItemMyWishlist) : BFLocalizedString(kTranslationMyWishlist, @"Wishlist"),
             @(BFUserProfileItemLogin)    : BFLocalizedString(kTranslationLogin, @"Login")
             };
}

+ (NSDictionary *)infoSettingsItemDisplayNames {
    return @{@(BFInfoSettingsItemBranches)    : BFLocalizedString(kTranslationBranches, @"Branches"),
             @(BFInfoSettingsItemCountry)  : BFLocalizedString(kTranslationCountryAndCurrency, @"Country")
             };
}


#pragma mark - API Names Mapping

+ (NSDictionary *)menuCategoryAPINames {
    return @{@(BFMenuCategoryMen)    : @"men",
             @(BFMenuCategoryWomen)    : @"women",
             @(BFMenuCategoryNone)    : @"",
             };
}

+ (NSDictionary *)staticMenuCategoryAPINames {
    return @{@(BFStaticMenuCategoryPopular) : @"popular",
             @(BFStaticMenuCategorySale)    : @"sale",
             };
}

+ (NSDictionary *)sortTypeAPINames {
    return @{@(BFSortTypePopularity)   : @"popularity",
             @(BFSortTypeNewest)       : @"newest",
             @(BFSortTypeHighestPrice) : @"price_DESC",
             @(BFSortTypeLowestPrice)  : @"price_ASC"
             };
}

+ (NSDictionary *)linkTypeAPINames {
    return @{
             @(BFLinkTypeDetail)  : @"detail",
             @(BFLinkTypeList)    : @"list",
             };
}

+ (NSDictionary *)filterTypeAPINames {
    return @{
             @(BFNProductFilterTypeColor)      : @"color",
             @(BFNProductFilterTypeSelect)     : @"select",
             @(BFNProductFilterTypeRange)      : @"range"
             };
}


#pragma mark - Other Enum Mapping

+ (NSDictionary *)shopUACodes {
    return @{
             @(BFShopIdentificationOpenShop)  : @"UA-70002133-2"
             };
}

+ (NSDictionary *)staticMenuCategoryIcons {
    return @{@(BFStaticMenuCategoryPopular) : [UIImage imageNamed:@"MenuStarIcon"],
             @(BFStaticMenuCategorySale)      : [UIImage imageNamed:@"MenuSaleIcon"],
             };
}

+ (NSDictionary *)addressItemsToRows {
    return @{
      @(BFAddressItemName) : @(BFAddressRowName),
      @(BFAddressItemEmail) : @(BFAddressRowEmail),
      @(BFAddressItemStreet) : @(BFAddressRowStreetHouseNumber),
      @(BFAddressItemHouseNumber) : @(BFAddressRowStreetHouseNumber),
      @(BFAddressItemCity) : @(BFAddressRowCityPostalCode),
      @(BFAddressItemPostalCode) : @(BFAddressRowCityPostalCode),
      @(BFAddressItemPhoneNumber) : @(BFAddressRowPhoneNumber),
      };
}

+ (NSDictionary *)shippingPaymentItemsToRows {
    return @{
             @(BFShippingAndPaymentItemUnkown) : @(BFShippingAndPaymentRowShipping),
             @(BFShippingAndPaymentItemShipping) : @(BFShippingAndPaymentRowShipping),
             @(BFShippingAndPaymentItemPayment) : @(BFShippingAndPaymentRowPayment),
             };
}

#pragma mark - Translations (Display Names)

+ (NSString *)menuCategoryDisplayName:(BFMenuCategory)menuCategory {
    NSDictionary *displayNames = [self menuCategoryDisplayNames];
    return menuCategory < displayNames.count ? displayNames[@(menuCategory)] : nil;
}

+ (NSString *)staticMenuCategoryDisplayName:(BFStaticMenuCategory)staticMenuCategory {
    NSDictionary *displayNames = [self staticMenuCategoryDisplayNames];
    return staticMenuCategory < displayNames.count ? displayNames[@(staticMenuCategory)] : nil;
}

+ (NSString *)sortTypeDisplayName:(BFSortType)sortType {
    NSDictionary *displayNames = [self sortTypeDisplayNames];
    return sortType < displayNames.count ? displayNames[@(sortType)] : nil;
}

+ (NSString *)userProfileItemDisplayName:(BFUserProfileItem)userProfileItem {
    NSDictionary *userProfileItems = [self userProfileItemDisplayNames];
    return userProfileItems[@(userProfileItem)];
}

+ (NSString *)infoSettingsItemDisplayName:(BFInfoSettingsItem)infoSettingsItem {
    NSDictionary *infoSettingsItems = [self infoSettingsItemDisplayNames];
    return infoSettingsItems[@(infoSettingsItem)];
}


#pragma mark - Translations (API Names)

+ (BFSortType)sortTypeFromAPIName:(NSString *)sortTypeAPIName {
    NSDictionary *APINames = [self sortTypeAPINames];
    NSArray *sortTypes = [APINames allKeysForObject:sortTypeAPIName];
    return sortTypes.count ? [[sortTypes firstObject]integerValue] : BFSortTypePopularity;
}

+ (NSNumber *)filterTypeFromAPIName:(NSString *)filterTypeAPIName {
    NSDictionary *APINames = [self filterTypeAPINames];
    NSArray *filterTypes = [APINames allKeysForObject:filterTypeAPIName];
    return [filterTypes firstObject];
}

+ (NSString *)sortTypeAPIName:(BFSortType)sortType {
    NSDictionary *APINames = [self sortTypeAPINames];
    return sortType < APINames.count ? APINames[@(sortType)] : nil;
}

+ (NSString *)staticMenuCategoryAPIName:(BFStaticMenuCategory)staticMenuCategory {
    NSDictionary *APINames = [self staticMenuCategoryAPINames];
    return staticMenuCategory < APINames.count ? APINames[@(staticMenuCategory)] : nil;
}

+ (NSString *)menuCategoryAPIName:(BFMenuCategory)menuCategory {
    NSDictionary *APINames = [self menuCategoryAPINames];
    return menuCategory < APINames.count ? APINames[@(menuCategory)] : nil;
}

+ (NSNumber *)linkTypeFromAPIName:(NSString *)linkTypeAPIName {
    NSDictionary *APINames = [self linkTypeAPINames];
    NSArray *linkTypes = [APINames allKeysForObject:linkTypeAPIName];
    return [linkTypes firstObject];
}


#pragma mark - Translations

+ (NSString *)shopUACode:(BFShopIdentification)shopIdentification {
    NSDictionary *shopUACodes = [self shopUACodes];
    return shopUACodes[@(shopIdentification)];
}

+ (UIImage *)staticMenuCategoryIcon:(BFStaticMenuCategory)staticMenuCategory {
    NSDictionary *icons = [self staticMenuCategoryIcons];
    return icons[@(staticMenuCategory)];
}


#pragma mark - Address Items and Rows

+ (NSNumber *)addressItemFromRow:(BFAddressRow)row {
    NSDictionary *items = [self addressItemsToRows];
    NSArray *rows = [items allKeysForObject:@(row)];
    return [rows firstObject];
}

+ (NSNumber *)addressRowFromItem:(BFAddressItem)item {
    NSDictionary *items = [self addressItemsToRows];
    return items[@(item)];
}

#pragma mark - Shipping & Payment Items and Rows

+ (NSNumber *)shippingPaymentItemFromRow:(BFShippingAndPaymentRow)row {
    NSDictionary *items = [self shippingPaymentItemsToRows];
    NSArray *rows = [items allKeysForObject:@(row)];
    return rows ? [rows firstObject] : nil;
}

+ (NSNumber *)shippingPaymentRowFromItem:(BFShippingAndPaymentItem)item {
    NSDictionary *items = [self shippingPaymentItemsToRows];
    return items[@(item)];
}


@end
