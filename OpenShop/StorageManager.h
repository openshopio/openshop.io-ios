//
//  StorageManager.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


@import Foundation;
@import CoreData;

#import "BFAppStructure.h"
#import "BFDataRequestPagerInfo.h"
#import "BFDataRequestProductInfo.h"
#import "BFAPIRequestCartProductInfo.h"
#import "BFDataRequestCartDiscountInfo.h"
#import "BFDataRequestCartProductInfo.h"
#import "BFDataRequestWishlistInfo.h"
#import "BFDataRequestOrderInfo.h"
#import "BFAPIRequestOrderInfo.h"
#import "BFShop.h"
#import "BFInfoPage.h"
#import "BFProduct.h"
#import "BFCartDiscountItem.h"
#import "BFCartDelivery.h"
#import "BFWishlistItem.h"
#import "BFSearchQuery.h"
#import "BFSearchSuggestion.h"
#import "BFCategory.h"
#import "BFTranslation.h"
#import "BFProductVariantColor.h"
#import "BFProductVariantSize.h"
#import "BFCartProductItem.h"
#import "BFOrderShipping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `StorageManager` is designed as Core Data model access layer. Its main purpose is to simplify
 * data fetching, updating and saving with active record pattern. It makes use of `MagicalRecord`
 * library iplementing the active record pattern. It supplies methods for managed object model
 * entities management and is directly connected to the generated core data models.
 */
@interface StorageManager : NSObject


#pragma mark - Inititialization & Clean up

/**
 * Class method to access the static data model access layer instance.
 *
 * @return Singleton instance of the `StorageManager` class.
 */
+ (instancetype)defaultManager;


#pragma mark - Managed Object Contexts

/**
 * Returns the main queue context associated with the main queue.
 *
 * @return The main queue context.
 */
- (NSManagedObjectContext *)mainQueueContext;
/**
 * Returns the private queue context associated with the private dispatch queue.
 *
 * @return The private queue context.
 */
- (NSManagedObjectContext *)privateQueueContext;


#pragma mark - Data Fetching - Categories, Banners

/**
 * Retrieves banners information with respect to the specified pager information.
 *
 * @param info The pager information.
 * @return The resulting array of banners data models.
 */
- (NSArray *)findBannersWithInfo:(BFDataRequestPagerInfo *)info;
/**
 * Retrieves structure of categories.
 *
 * @return The resulting array of categories data models.
 */
- (NSArray *)findCategories;
/**
 * Retrieves structure of categories for specified menu category.
 *
 * @param menuCategory The menu category.
 * @return The resulting array of categories data models.
 */
- (NSArray *)findCategoriesWithMenuCategory:(BFMenuCategory)menuCategory;


#pragma mark - Data Fetching - Shops

/**
 * Retrieves shops information.
 *
 * @return The resulting array of shops data models.
 */
- (NSArray *)findShops;
/**
 * Retrieves shop with specified identification.
 *
 * @param identification The shop identification.
 * @return The resulting shop data model.
 */
- (nullable BFShop *)findShopWithIdentification:(NSNumber *)identification;


#pragma mark - Data Fetching - Shop Branches, Regions

/**
 * Retrieves shop branches information.
 *
 * @return The resulting array of branches data models.
 */
- (NSArray *)findBranches;
/**
 * Retrieves shop regions information.
 *
 * @return The resulting array of regions data models.
 */
- (NSArray *)findRegions;


#pragma mark - Application Info

/**
 * Retrieves information pages.
 *
 * @return The resulting array of pages data models.
 */
- (NSArray *)findInfoPages;
/**
 * Retrieves information page with specified identification.
 *
 * @param identification The information page identification.
 * @return The resulting page data model.
 */
- (nullable BFInfoPage *)findInfoPageWithIdentification:(NSNumber *)identification;


#pragma mark - Products & Variants

/**
 * Retrieves products matching specified product attributes.
 *
 * @param productInfo The product attributes.
 * @return The resulting array of products data models.
 */
- (NSArray *)findProductsWithInfo:(BFDataRequestProductInfo *)productInfo;
/**
 * Retrieves product with specified identification.
 *
 * @param identification The product identification.
 * @return The resulting product data model.
 */
- (nullable BFProduct *)findProductWithIdentification:(NSNumber *)identification;
/**
 * Retrieves product variant with specified identification.
 *
 * @param identification The product variant identification.
 * @return The resulting product variant data model.
 */
- (nullable BFProductVariant *)findProductVariantWithIdentification:(NSNumber *)identification;
/**
 * Retrieves product variant colors for specified products and their variants sizes.
 *
 * @param products The array of products.
 * @param sizes The products variants sizes.
 * @return The resulting array of product variant colors data models.
 */
- (NSArray *)findProductVariantColorsForProducts:(NSArray *)products withSizes:(nullable NSArray *)sizes;
/**
 * Retrieves product variant sizes for specified products and their variants colors.
 *
 * @param products The array of products.
 * @param colors The products variants colors.
 * @return The resulting array of product variant sizes data models.
 */
- (NSArray *)findProductVariantSizesForProducts:(NSArray *)products withColors:(nullable NSArray *)colors;
/**
 * Retrieves product variant of specified product with specified color and size.
 *
 * @param product The product.
 * @param color The product variant color.
 * @param size The product variant size.
 * @return The resulting product variant data model.
 */
- (nullable BFProductVariant *)findProductVariantForProduct:(BFProduct *)product withColor:(nullable BFProductVariantColor *)color size:(nullable BFProductVariantSize *)size;


#pragma mark - Shopping Cart Contents

/**
 * Retrieves shopping cart contents.
 *
 * @return The resulting array of shopping cart product items data models.
 */
- (NSArray *)findShoppingCartContents;


#pragma mark - Shopping Cart Modification

/**
 * Inserts product variant with its information to the shopping cart.
 *
 * @param productVariant The product variant data model.
 * @param cartInfo The product variant shopping cart information.
 */
- (void)addProductVariant:(BFProductVariant *)productVariant toCartWithCartInfo:(BFDataRequestCartProductInfo *)cartInfo;
/**
 * Updates product variant in the shopping cart with its information.
 *
 * @param productVariant The product variant.
 * @param cartInfo The product variant shopping cart information.
 */
- (void)updateProductVariant:(BFProductVariant *)productVariant inCartWithCartInfo:(BFDataRequestCartProductInfo *)cartInfo;
/**
 * Removes product variant from the shopping cart.
 *
 * @param productVariant The product variant.
 */
- (void)deleteProductVariantInCart:(BFProductVariant *)productVariant;
/**
 * Removes product item from the shopping cart.
 *
 * @param cartProduct The shopping cart product item.
 * @param completionBlock Method completion block
 */
- (void)deleteProductCartItem:(BFCartProductItem *)cartProduct completionBlock:(void(^)(NSError *error))completionBlock;


#pragma mark - Shopping Cart Discounts

/**
 * Retrieves shopping cart discount items.
 *
 * @return The resulting array of shopping cart discount items data models.
 */
- (NSArray *)findShoppingCartDiscounts;
/**
 * Inserts shopping cart discount item specified with discount information to the shopping cart.
 *
 * @param cartInfo The shopping cart discount information.
 */
- (void)addDiscountToCartWithInfo:(BFDataRequestCartDiscountInfo *)cartInfo;
/**
 * Removes shopping cart discount item from the shopping cart.
 *
 * @param discountItem The shopping cart discount item.
 * @param completionBlock Method completion block
 */
- (void)deleteDiscountInCart:(BFCartDiscountItem *)discountItem completionBlock:(void(^)(NSError *error))completionBlock;


#pragma mark - Shopping Cart Delivery Info

/**
 * Retrieves shopping cart delivery information.
 *
 * @return The resulting array of shopping cart delivery information data models.
 */
- (NSArray *)findShoppingCartDeliveryInfo;
/**
 * Retrieves delivery info with specified identification.
 *
 * @param identification Delivery identification.
 * @return The resulting delivery data model.
 */
- (nullable BFCartDelivery *)findShoppingCartDeliveryWithIdentification:(NSNumber *)identification;
/**
 * Retrieves delivery info with specified branch.
 *
 * @param branch Branch associated with the delivery.
 * @return The resulting delivery info data model.
 */
- (nullable BFCartDelivery *)findShoppingCartDeliveryWithBranch:(BFBranch *)branch;
/**
 * Retrieves payment info with specified identification.
 *
 * @param identification Payment info identification.
 * @return The resulting payment info data model.
 */
- (nullable BFCartPayment *)findShoppingCartPaymentWithIdentification:(NSNumber *)identification;
/**
 * Retrieves all payments for the given BFCartDelivery id.
 *
 * @param deliveryIdentification Cart delivery identification.
 * @return The resulting array of related payments.
 */
- (nullable NSArray<BFCartPayment *>*)findShoppingCartPaymentsWithDeliveryIdentification:(NSNumber *)deliveryIdentification;

#pragma mark - Shopping Cart Reservations

/**
 * Retrieves reserved product variants in the shopping cart.
 *
 * @return The resulting array of reserved shopping cart product items data models.
 */
- (NSArray *)findReservedProductVariants;
/**
 * Removes reserved product variant from the shopping cart.
 *
 * @param productVariant The product variant.
 */
- (void)deleteReservedProductVariant:(BFProductVariant *)productVariant;


#pragma mark - Orders & Shipping

/**
 * Retrieves order shipping information.
 *
 * @return The resulting array of order shipping data models.
 */
- (NSArray *)findShipping;
/**
 * Retrieves orders with respect to the specified pager information.
 *
 * @param info The pager information.
 * @return The resulting array of orders data models.
 */
- (NSArray *)findOrdersWithInfo:(BFDataRequestPagerInfo *)info;
/**
 * Creates new order with specified order shipping, payment and information.
 *
 * @param orderInfo The order information.
 * @param shipping The order shipping.
 * @param payment The order payment.
 */
- (void)createOrderWithCartShipping:(BFOrderShipping *)shipping payment:(BFCartPayment *)payment orderInfo:(BFDataRequestOrderInfo *)orderInfo;


#pragma mark - Wishlist

/**
 * Retrieves wishlist contents.
 *
 * @return The resulting array of wishlist items data models.
 */
- (NSArray *)findWishlistContents;
/**
 * Inserts product variant with its information to the wishlist.
 *
 * @param productVariant The product variant data model.
 * @param wishlistInfo The product variant wishlist information.
 */
- (void)addProductVariant:(BFProductVariant *)productVariant toWishlistWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo;
/**
 * Removes product variant from the wishlist.
 *
 * @param productVariant The product variant.
 */
- (void)deleteProductVariantInWishlist:(BFProductVariant *)productVariant;
/**
 * Moves wishlist item with its information to the shopping cart.
 *
 * @param wishlistItem The wishlist item.
 * @param cartInfo The wishlist item shopping cart information.
 */
- (void)moveWishlistItem:(BFWishlistItem *)wishlistItem toCartWithCartInfo:(BFDataRequestCartProductInfo *)cartInfo;
/**
 * Checks product variant existence in the wishlist.
 *
 * @param productVariant The product variant data model.
 * @return TRUE if the product variant exists in the wishlist, else FALSE.
 */
- (BOOL)isProductVariantInWishlist:(BFProductVariant *)productVariant;


#pragma mark - Search Suggestions

/**
 * Retrieves search suggestions based on the BFCategory retrieved previously
 * from the server optionally with respect to the limit.
 *
 * @param suggestionPrefix The prefix for the returned suggestions.
 * @param limit The maximum number of search suggestions to be returned.
 * @return The resulting array of search suggestions data models.
 */
- (NSArray *)findSearchSuggestionsWithPrefix:(NSString *)suggestionPrefix limit:(nullable NSNumber *)limit;
/**
 * Retrieves search suggestion with specified suggestion string in managed object context.
 *
 * @param suggestionString The suggestion string.
 * @param context The managed object context.
 * @return The resulting search query.
 */
- (BFSearchSuggestion *)findSearchSuggestionWithString:(NSString *)suggestionString inContext:(nullable NSManagedObjectContext *)context;
/**
 * Adds search suggestion string.
 *
 * @param suggestionString The search query string.
 */
- (void)addSearchSuggestionString:(NSString *)suggestionString;
/**
 * Adds search suggestions from names of the categories stored in the array.
 *
 * @param categories The category array.
 */
- (void)addSearchSuggestionsFromCategories:(NSArray<BFCategory *> *)categories;
/**
 * Removes search suggestion.
 *
 * @param suggestion The search query.
 */
- (void)deleteSearchSuggestion:(BFSearchSuggestion *)suggestion;


#pragma mark - Search Queries

/**
 * Retrieves last searched queries optionally with respect to the limit.
 *
 * @param limit The maximum number of search queries to be returned.
 * @return The resulting array of search queries data models.
 */
- (NSArray *)findLastSearchedQueriesWithLimit:(nullable NSNumber *)limit;
/**
 * Retrieves most searched queries optionally with respect to the limit and minimum number of search query occurences.
 *
 * @param limit The maximum number of search queries to be returned.
 * @param occurences The minimum number of search query occurences.
 * @return The resulting array of search queries data models.
 */
- (NSArray *)findMostSearchedQueriesWithLimit:(nullable NSNumber *)limit minOccurences:(nullable NSNumber *)occurences;
/**
 * Retrieves search query with specified query string in managed object context.
 *
 * @param queryString The query string.
 * @param context The managed object context.
 * @return The resulting search query.
 */
- (BFSearchQuery *)findSearchQueryWithQueryString:(NSString *)queryString inContext:(nullable NSManagedObjectContext *)context;

/**
 * Inserts search query string to the last searched queries.
 *
 * @param queryString The search query string.
 */
- (void)addSearchQueryString:(NSString *)queryString;
/**
 * Removes search query from the last searched queries.
 *
 * @param query The search query.
 */
- (void)deleteSearchQuery:(BFSearchQuery *)query;


#pragma mark - Translations

/**
 * Retrieves translation with specified translation string key in the currently selected language.
 *
 * @param key The translation string key.
 * @return The translation data model.
 */
- (nullable BFTranslation *)findTranslationWithKey:(NSString *)key;
/**
 * Retrieves translation with specified translation string key in the language.
 *
 * @param language The language code identifying language.
 * @param key The translation string key.
 * @return The translation data model.
 */
- (nullable BFTranslation *)findTranslationWithLanguage:(BFLanguage)language key:(NSString *)key;
/**
 * Retrieves translation string with specified translation string key in the currently selected language. If none translation
 * is found it attempts to find static local translation with optional default value.
 *
 * @param key The translation string key.
 * @param defaultValue The default translation value.
 * @return The translation string.
 */
- (NSString *)findTranslationStringWithKey:(NSString *)key defaultValue:(NSString *)defaultValue;
/**
 * Retrieves translation string with specified translation string key in the language. If none translation is found it
 * attempts to find static local translation with optional default value.
 *
 * @param language The language code identifying language.
 * @param key The translation string key.
 * @param defaultValue The default value.
 * @return The translation string.
 */
- (NSString *)findTranslationStringWithLanguage:(BFLanguage)language key:(NSString *)key defaultValue:(NSString *)defaultValue;


NS_ASSUME_NONNULL_END

@end
