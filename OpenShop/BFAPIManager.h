//
//  BFAPIManager.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BFAPIRequestUserInfo.h"
#import "BFAPIRequestDeviceInfo.h"
#import "BFDataRequestPagerInfo.h"
#import "BFDataRequestProductInfo.h"
#import "BFAPIRequestCartProductInfo.h"
#import "BFAPIRequestCartDiscountInfo.h"
#import "BFAPIRequestOrderInfo.h"
#import "BFDataRequestWishlistInfo.h"
#import "BFAppStructure.h"
#import "BFError.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * API info request completion block type.
 */
typedef void (^BFAPIInfoCompletionBlock)(_Nullable id response, NSError *_Nullable error);
/**
 * API data loading request completion block type.
 */
typedef void (^BFAPIDataLoadingCompletionBlock)(NSArray *_Nullable records, id _Nullable customResponse, NSError *_Nullable error);


/**
 * Custom web API client. Provides access to the data service and maintains communication headers
 * along with authorization header when appropriate. Based on AFNetworking `AFHTTPSessionManager`.
 */
@interface BFAPIManager : AFHTTPSessionManager

/**
 * Class method to access the static API manager instance.
 *
 * @return Singleton instance of the `BFAPIManager` class.
 */
+ (instancetype)sharedManager;


#pragma mark - Authorization

/**
 * Disables the user authorization header for future API requests.
 */
- (void)disableAuthorization;
/**
 * Conditionally disables the user authorization header for a single API request.
 */
- (void)disableAuthorizationForSingleRequest;
/**
 * Enables the user authorization header for future API requests.
 */
- (void)enableAuthorization;


#pragma mark - User Login & Registration

/**
 * Analyzes user request response dictionary and saves required data.
 *
 * @param response A dictionary representing request response containg JSON data.
 * @return An optional error that might occur during parsing or saving the received data.
 */
- (BFError *)finishUserRequestWithResponse:(NSDictionary *)response;
/**
 * Registers user with specified information.
 *
 * @param info The user registration information.
 * @param block The block to call when the request completes.
 */
- (void)registerUserWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(nullable BFAPIInfoCompletionBlock)block;
/**
 * Logs user in with specified information.
 *
 * @param info The user authentication information.
 * @param block The block to call when the request completes.
 */
- (void)loginUserWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(nullable BFAPIInfoCompletionBlock)block;
/**
 * Verifies user with specified information.
 *
 * @param info The user authentication information.
 * @param block The block to call when the request completes.
 */
- (void)verifyUserWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(nullable BFAPIInfoCompletionBlock)block;
/**
 * Verifies user with Facebook credentials.
 *
 * @param info The user's Facebook credentials.
 * @param block The block to call when the request completes.
 */
- (void)verifyUserWithFacebookInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock)block;

#pragma mark - User Details

/**
 * Retrieves user information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findUserDetailsWithCompletionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Updates user information.
 *
 * @param block The block to call when the request completes.
 */
- (void)updateUserDetailsWithCompletionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Updates user information with temporary access token and user identification.
 * @param accessToken The temporary access token.
 * @param identification The user unique identification.
 * @param block The block to call when the request completes.
 */
- (void)updateUserDetailsWithAccessToken:(nullable NSString *)accessToken userIdentication:(NSNumber *)identification completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Initiates user password change with specified information.
 *
 * @param info User information.
 * @param block The block to call when the request completes.
 */
- (void)changeUserPasswordWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Resets user password with specified information.
 *
 * @param info User information.
 * @param block The block to call when the request completes.
 */
- (void)resetUserPasswordWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(nullable BFAPIInfoCompletionBlock) block;


#pragma mark - Device & Application Info

/**
 * Registers device for push notifications with specified information.
 *
 * @param info The device information.
 * @param block The block to call when the request completes.
 */
- (void)registerDeviceWithInfo:(BFAPIRequestDeviceInfo *)info completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Retrieves terms and conditions information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findTermsAndConditionsWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves information pages.
 *
 * @param block The block to call when the request completes.
 */
- (void)findInfoPagesWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves information page with specified identification.
 *
 * @param identification The information page identification.
 * @param block The block to call when the request completes.
 */
- (void)findInfoPageWithIdentification:(NSNumber *)identification completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;


#pragma mark - Shops

/**
 * Retrieves shops information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findShopsWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves shop with specified identification.
 *
 * @param identification The shop identification.
 * @param block The block to call when the request completes.
 */
- (void)findShopWithIdentification:(NSNumber *)identification completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;


#pragma mark - Categories, Banners

/**
 * Retrieves structure of categories.
 *
 * @param block The block to call when the request completes.
 */
- (void)findCategoriesWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves structure of categories for specified menu category.
 *
 * @param menuCategory The menu category.
 * @param block The block to call when the request completes.
 */
- (void)findCategoriesWithMenuCategory:(BFMenuCategory)menuCategory completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves banners information with respect to the specified pager information.
 *
 * @param info The pager information.
 * @param block The block to call when the request completes.
 */
- (void)findBannersWithInfo:(BFDataRequestPagerInfo *)info completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;


#pragma mark - Shop Branches, Regions

/**
 * Retrieves shop branches information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findBranchesWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves shop regions information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findRegionsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block;


#pragma mark - Products & Variants

/**
 * Retrieves products matching specified product attributes.
 *
 * @param productInfo The product attributes.
 * @param block The block to call when the request completes.
 */
- (void)findProductsWithInfo:(BFDataRequestProductInfo *)productInfo completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves product details matching specified product identification and requested information.
 *
 * @param productInfo The product identification and requested information.
 * @param block The block to call when the request completes.
 */
- (void)findProductDetailsWithInfo:(BFDataRequestProductInfo *)productInfo completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves product variant details matching specified product variant identification and requested information.
 *
 * @param productInfo The product variant identification and requested information.
 * @param block The block to call when the request completes.
 */
- (void)findProductVariantDetailsWithInfo:(BFDataRequestProductInfo *)productInfo completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;


#pragma mark - Shopping Cart Contents & Info

/**
 * Retrieves shopping cart contents.
 *
 * @param block The block to call when the request completes.
 */
- (void)findShoppingCartContentsWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves shopping cart information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findShoppingCartInfoWithCompletionBlock:(nullable BFAPIInfoCompletionBlock) block;


#pragma mark - Shopping Cart Modification

/**
 * Inserts product variant specified with identification and its quantity to the shopping cart.
 *
 * @param cartInfo The product variant identification and its quantity.
 * @param block The block to call when the request completes.
 */
- (void)addProductVariantToCartWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Updates product variant and its quantity specified with cart identification in the shopping cart.
 *
 * @param cartInfo The cart product identification.
 * @param block The block to call when the request completes.
 */
- (void)updateProductVariantInCartWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Removes product variant specified with cart identification from the shopping cart.
 *
 * @param cartInfo The cart product identification.
 * @param block The block to call when the request completes.
 */
- (void)deleteProductVariantInCartWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;


#pragma mark - Shopping Cart Discounts

/**
 * Inserts shopping cart discount specified with discount code to the shopping cart.
 *
 * @param cartInfo The shopping cart discount code.
 * @param block The block to call when the request completes.
 */
- (void)addDiscountToCartWithInfo:(BFAPIRequestCartDiscountInfo *)cartInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Removes shopping cart discount specified with identification from the shopping cart.
 *
 * @param cartInfo The shopping cart discount identification.
 * @param block The block to call when the request completes.
 */
- (void)deleteDiscountInCartWithInfo:(BFAPIRequestCartDiscountInfo *)cartInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;


#pragma mark - Shopping Cart Delivery Info

/**
 * Retrieves shopping cart delivery information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findShoppingCartDeliveryInfoWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;


#pragma mark - Shopping Cart Reservations

/**
 * Retrieves reserved product variants in the shopping cart.
 *
 * @param block The block to call when the request completes.
 */
- (void)findReservedProductVariantsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block;
/**
 * Removes reserved product variant in the shopping cart specified with shopping cart item identification.
 *
 * @param cartInfo The shopping cart item identification.
 * @param block The block to call when the request completes.
 */
- (void)deleteReservedProductVariantWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block;


#pragma mark - Orders & Shipping

/**
 * Retrieves order shipping information.
 *
 * @param block The block to call when the request completes.
 */
- (void)findShippingWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves orders with respect to the specified pager information.
 *
 * @param info The pager information.
 * @param block The block to call when the request completes.
 */
- (void)findOrdersWithInfo:(BFDataRequestPagerInfo *)info completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Retrieves order details specified with order identification.
 *
 * @param orderInfo The order identification info.
 * @param block The block to call when the request completes.
 */
- (void)findOrderDetailsWithInfo:(BFAPIRequestOrderInfo *)orderInfo completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Creates new order with details specified in order information.
 *
 * @param orderInfo The order information.
 * @param block The block to call when the request completes.
 */
- (void)createOrderWithInfo:(BFAPIRequestOrderInfo *)orderInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;


#pragma mark - Wishlist

/**
 * Retrieves wishlist contents.
 *
 * @param block The block to call when the request completes.
 */
- (void)findWishlistContentsWithCompletionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;
/**
 * Inserts product variant specified with identification to the wishlist.
 *
 * @param wishlistInfo The product variant identification.
 * @param block The block to call when the request completes.
 */
- (void)addProductVariantToWishlistWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Removes wishlist item specified with product variant identification or its wishlist identification from the wishlist.
 *
 * @param wishlistInfo The product variant identification or the wishlist item identification.
 * @param block The block to call when the request completes.
 */
- (void)deleteProductVariantInWishlistWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(nullable BFAPIInfoCompletionBlock) block;
/**
 * Moves wishlist item specified with wishlist identification to the shopping cart.
 *
 * @param wishlistInfo The wishlist item identification.
 * @param block The block to call when the request completes.
 */
- (void)moveProductVariantInWishlistToCartWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(BFAPIInfoCompletionBlock) block;
/**
 * Checks product variant existence in the wishlist specified with product variant identification.
 *
 * @param wishlistInfo The product variant identification.
 * @param block The block to call when the request completes.
 */
- (void)isProductVariantInWishlist:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(BFAPIInfoCompletionBlock) block;


#pragma mark - Translations

/**
 * Retrieves translation strings for specified language code.
 *
 * @param languageCode The translation language code.
 * @param block The block to call when the request completes.
 */
- (void)findTranslationWithLanguageCode:(NSString *)languageCode completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block;



@end

NS_ASSUME_NONNULL_END
