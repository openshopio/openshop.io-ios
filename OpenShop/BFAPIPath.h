//
//  BFAPIPath.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

/**
 * API service host URL.
 */
static NSString *const BFAPIRootURL                             = @"http://private-4bdb8-bfashionapibfversion.apiary-mock.com";
/**
 * API service default version.
 */
static NSString *const BFAPIDefaultVersion                      = @"";

/**
 * API service user registration request path.
 */
static NSString *const BFAPIRequestPathUserRegister             = @"users/register";
/**
 * API service user login request path.
 */
static NSString *const BFAPIRequestPathUserLogin                = @"login/email";
/**
 * API service user verification request path.
 */
static NSString *const BFAPIRequestPathUserVerify               = @"users/verify";
/**
 * API service user Facebook credentials verification request path.
 */
static NSString *const BFAPIRequestPathUserFacebookVerify       = @"login/facebook";

/**
 * API service user password request request path.
 */
static NSString *const BFAPIRequestPathUserPasswordReset        = @"users/reset-password";
/**
 * API service user details request path.
 */
static NSString *const BFAPIRequestPathUserDetails              = @"users";
/**
 * API service user password change request path.
 */
#define BFAPIRequestPathUserPasswordChange(userID)                [NSString stringWithFormat:@"users/%@/password", userID]

/**
 * API service device registration request path.
 */
static NSString *const BFAPIRequestPathDeviceRegistration       = @"devices";
/**
 * API service terms and conditions request path.
 */
static NSString *const BFAPIRequestPathTermsAndConditions       = @"pages/terms";
/**
 * API service information pages request path.
 */
static NSString *const BFAPIRequestPathInfoPages                = @"pages";
/**
 * API service categories request path.
 */
static NSString *const BFAPIRequestPathCategories               = @"navigation_drawer";
/**
 * API service banners request path.
 */
static NSString *const BFAPIRequestPathBanners                  = @"banners";
/**
 * API service shop branches request path.
 */
static NSString *const BFAPIRequestPathShopBranches             = @"branches";
/**
 * API service shop regions request path.
 */
static NSString *const BFAPIRequestPathShopRegions              = @"regions";

/**
 * API service shops request path.
 */
static NSString *const BFAPIRequestPathShops                    = @"shops";
/**
 * API service products request path.
 */
static NSString *const BFAPIRequestPathProducts                 = @"products";
/**
 * API service product variants request path.
 */
#define BFAPIRequestPathProductVariants(productID)                [NSString stringWithFormat:@"products/%@/variants", productID]
/**
 * API service shopping cart contents request path.
 */
static NSString *const BFAPIRequestPathShoppingCart             = @"cart";
/**
 * API service shopping cart information request path.
 */
static NSString *const BFAPIRequestPathShoppingCartInfo         = @"cart/info";
/**
 * API service shopping cart discounts request path.
 */
static NSString *const BFAPIRequestPathShoppingCartDiscounts    = @"cart/discounts";
/**
 * API service shopping cart delivery information request path.
 */
static NSString *const BFAPIRequestPathShoppingCartDeliveryInfo = @"cart/delivery-info";
/**
 * API service orders request path.
 */
static NSString *const BFAPIRequestPathOrders                   = @"orders";
/**
 * API service orders shipping request path.
 */
static NSString *const BFAPIRequestPathShipping                 = @"shipping";
/**
 * API service wishlist request path.
 */
static NSString *const BFAPIRequestPathWishlist                 = @"wishlist";
/**
 * API service wishlist product request path.
 */
static NSString *const BFAPIRequestPathWishlistProduct          = @"wishlist/product";
/**
 * API service wishlist product move to shopping cart request path.
 */
#define BFAPIRequestPathWishlistToCart(wishlistID)                [NSString stringWithFormat:@"wishlist/%@/cart", wishlistID]
/**
 * API service wishlist product existence request path.
 */
static NSString *const BFAPIRequestPathWishlistIsProductIn      = @"wishlist/is-in-wishlist";
/**
 * API service reserved products request path.
 */
static NSString *const BFAPIRequestPathReservations             = @"reservations";
/**
 * API service translation strings request path.
 */
static NSString *const BFAPIRequestPathTranslations             = @"translations";

/**
 * `BFAPIPath` provides formatted API request paths. Paths are constructed with specified API version, server
 * relative resource path and optional parameters. Path can be retrieved either as absolute or relative.
 */
@interface BFAPIPath : NSObject


#pragma mark - Base API Paths

/**
 * API root URL in absolute format.
 *
 * @return The API root URL.
 */
+ (NSString *)APIBaseURL;
/**
 * API root URL with specified API version in absolute format.
 *
 * @param version The API version.
 * @return The API root URL with version.
 */
+ (NSString *)APIBaseURLWithVersion:(NSString *)version;
/**
 * API root URL with resource path and path params in absolute format.
 *
 * @param path The additional resource path.
 * @param params The additional resource path parameters.
 * @return The API root URL with path and path params.
 */
+ (NSString *)APIBaseURLWithPath:(NSString *)path params:(NSArray *)params;
/**
 * API root URL with resource path and path params. URL will be in relative format when relative flag is TRUE.
 *
 * @param path The additional resource path.
 * @param params The additional resource path parameters.
 * @param relative The relative URL flag.
 * @return The API root URL with path and path params.
 */
+ (NSString *)APIBaseURLWithPath:(NSString *)path params:(NSArray *)params relative:(BOOL)relative;
/**
 * API root URL with version, resource path and path params in absolute format.
 *
 * @param path The additional resource path.
 * @param version The API version.
 * @param params The additional resource path parameters.
 * @return The API root URL with version, path and path params.
 */
+ (NSString *)APIBaseURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params;
/**
 * API root URL with version, resource path and path params. URL will be in relative format when relative flag is TRUE.
 *
 * @param path The additional resource path.
 * @param version The API version.
 * @param params The additional resource path parameters.
 * @param relative The relative URL flag.
 * @return The API root URL with version, path and path params.
 */
+ (NSString *)APIBaseURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params relative:(BOOL)relative;


#pragma mark - Shop API Paths

/**
 * API selected shop root URL in relative format. Selected shop is stored in `BFAppPreferences`.
 *
 * @return The API selected shop root URL.
 */
+ (NSString *)APIShopURL;
/**
 * API selected shop root URL with version in relative format. Selected shop is stored in `BFAppPreferences`.
 *
 * @param version The API version.
 * @return The API selected shop root URL with version.
 */
+ (NSString *)APIShopURLWithVersion:(NSString *)version;
/**
 * API selected shop root URL with version. URL will be in relative format when relative flag is TRUE.
 * Selected shop is stored in `BFAppPreferences`.
 *
 * @param version The API version.
 * @param relative The relative URL flag.
 * @return The API selected shop root URL with version.
 */
+ (NSString *)APIRequestShopURLWithVersion:(NSString *)version relative:(BOOL)relative;
/**
 * API selected shop URL with resource path. Selected shop is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @return The API selected shop URL with path.
 */
+ (NSString *)APIRequestShopURLWithPath:(NSString *)path;
/**
 * API selected shop URL with resource path and path params. Selected shop is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @param params The additional resource path parameters.
 * @return The API selected shop URL with path and path params.
 */
+ (NSString *)APIRequestShopURLWithPath:(NSString *)path params:(NSArray *)params;
/**
 * API selected shop URL with resource path and version. URL will be in relative format when relative flag is TRUE.
 * Selected shop is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @param version The API version.
 * @param relative The relative URL flag.
 * @return The API selected shop URL with path and version.
 */
+ (NSString *)APIRequestShopURLWithPath:(NSString *)path version:(NSString *)version relative:(BOOL)relative;
/**
 * API selected shop URL with resource path, version and path params. URL will be in relative format when relative flag is TRUE.
 * Selected shop is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @param params The additional resource path parameters.
 * @param version The API version.
 * @param relative The relative URL flag.
 * @return The API selected shop URL with path, version and path params.
 */
+ (NSString *)APIRequestShopURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params relative:(BOOL)relative;


#pragma mark - Organization API Paths

/**
 * API selected organization root URL in relative format. Selected organization is stored in `BFAppPreferences`.
 *
 * @return The API selected organization root URL.
 */
+ (NSString *)APIOrganizationURL;
/**
 * API selected organization root URL with version in relative format. Selected organization is stored in `BFAppPreferences`.
 *
 * @param version The API version.
 * @return The API selected organization root URL with version.
 */
+ (NSString *)APIOrganizationURLWithVersion:(NSString *)version;
/**
 * API selected organization root URL with version. URL will be in relative format when relative flag is TRUE.
 * Selected organization is stored in `BFAppPreferences`.
 *
 * @param version The API version.
 * @param relative The relative URL flag.
 * @return The API selected organization root URL with version.
 */
+ (NSString *)APIRequestOrganizationURLWithVersion:(NSString *)version relative:(BOOL)relative;
/**
 * API selected organization URL with resource path. Selected organization is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @return The API selected organization URL with path.
 */
+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path;
/**
 * API selected organization URL with resource path and path params. Selected organization is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @param params The additional resource path parameters.
 * @return The API selected organization URL with path and path params.
 */
+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path params:(NSArray *)params;
/**
 * API selected organization URL with resource path and version. URL will be in relative format when relative flag is TRUE.
 * Selected organization is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @param version The API version.
 * @param relative The relative URL flag.
 * @return The API selected organization URL with path and version.
 */
+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path version:(NSString *)version relative:(BOOL)relative;
/**
 * API selected organization URL with resource path, version and path params. URL will be in relative format when relative flag is TRUE.
 * Selected organization is stored in `BFAppPreferences`.
 *
 * @param path The additional resource path.
 * @param params The additional resource path parameters.
 * @param version The API version.
 * @param relative The relative URL flag.
 * @return The API selected organization URL with path, version and path params.
 */
+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params relative:(BOOL)relative;



@end

NS_ASSUME_NONNULL_END
