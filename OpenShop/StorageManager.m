//
//  StorageManager.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "StorageManager.h"
#import "PersistentStorage.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>
#import <MagicalRecord/MagicalRecordShorthandMethodAliases.h>
#import "BFBanner.h"
#import "BFBranch.h"
#import "BFRegion.h"
#import "BFProductVariant.h"
#import "BFProductVariantColor.h"
#import "BFProductVariantSize.h"
#import "BFWishlistItem.h"
#import "BFCartProductItem.h"
#import "BFCartPayment.h"
#import "BFOrderItem.h"
#import "BFOrderShipping.h"
#import "BFOrder.h"
#import "BFAppPreferences.h"
#import "NSArray+BFObjectFiltering.h"

@interface StorageManager ()

/**
 * The main queue context.
 */
@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;
/**
 * The private queue context.
 */
@property (strong, nonatomic) NSManagedObjectContext *privateQueueContext;

@end



#pragma mark - Fetch Request Additions

/**
 * `BFNPagerInfo` category extends `NSFetchRequest` with a method to update its
 * attributes with paging information.
 */
@implementation NSFetchRequest (BFNPagerInfo)

- (instancetype)requestWithPagerInfo:(BFDataRequestPagerInfo *)info {
    if(info) {
        if(info.offset != nil) {
            self.fetchOffset = [info.offset integerValue];
        }
        if(info.limit != nil) {
            self.fetchLimit = [info.limit integerValue];
        }
    }
    return self;
}

@end



/**
 * `BFNProductInfo` category extends `NSFetchRequest` with a method to update its
 * attributes with product data model information.
 */
@implementation NSFetchRequest (BFNProductInfo)

- (instancetype)requestWithProductInfo:(BFDataRequestProductInfo *)info {
    if(info) {
        if(info.sortType != nil) {
            switch ([info.sortType integerValue]) {
                case BFSortTypeHighestPrice:
                    self.sortDescriptors = @[[[NSSortDescriptor alloc]initWithKey:@"price" ascending:NO]];
                case BFSortTypeLowestPrice:
                    self.sortDescriptors = @[[[NSSortDescriptor alloc]initWithKey:@"price" ascending:YES]];
            }
        }
    }
    return [self requestWithPagerInfo:info];
}

@end



@implementation StorageManager


#pragma mark - Inititialization & Clean up

+ (instancetype)defaultManager {
    static StorageManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    // execute initialization exactly once
    dispatch_once(&onceToken, ^{
        sharedManager = [[StorageManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        // do not auto create merged managed object model
        [MagicalRecord setShouldAutoCreateManagedObjectModel:false];
        // set default managed object model
        [MagicalRecord setDefaultModelNamed:[[PersistentStorage defaultStorage]managedObjectModelFileName]];
        // allow shorter non-prefixed methods
        [MagicalRecord enableShorthandMethods];
        // setup with persistent store 
        [MagicalRecord setupCoreDataStackWithStoreAtURL:[[PersistentStorage defaultStorage]persistentStoreURL]];
    }
    return self;
}

- (void)dealloc {
    [MagicalRecord cleanUp];
}


#pragma mark - Managed Object Contexts

- (NSManagedObjectContext *)mainQueueContext {
    if (!_mainQueueContext) {
        _mainQueueContext = [NSManagedObjectContext MR_defaultContext];
    }
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)privateQueueContext {
    if (!_privateQueueContext) {
        _privateQueueContext = [NSManagedObjectContext MR_rootSavingContext];
    }
    
    return _privateQueueContext;
}


#pragma mark - Data Fetching - Categories, Banners

- (NSArray *)findBannersWithInfo:(BFDataRequestPagerInfo *)info {
    NSFetchRequest *request = [BFBanner requestAll];
    return [BFBanner MR_executeFetchRequest:[request requestWithPagerInfo:info] inContext:[self privateQueueContext]];
}

- (NSArray *)findCategories {
    return [BFCategory findAllInContext:[self privateQueueContext]];
}

- (NSArray *)findCategoriesWithMenuCategory:(BFMenuCategory)menuCategory {
    return [BFCategory findByAttribute:@"menuCategory" withValue:[BFAppStructure menuCategoryDisplayName:menuCategory] inContext:[self privateQueueContext]];
}


#pragma mark - Data Fetching - Shops

- (NSArray *)findShops {
    return [BFShop findAllInContext:[self privateQueueContext]];
}

- (BFShop *)findShopWithIdentification:(NSNumber *)identification {
    return [BFShop findFirstByAttribute:@"shopID" withValue:identification inContext:[self privateQueueContext]];
}


#pragma mark - Data Fetching - Shop Branches, Regions

- (NSArray *)findBranches {
    return [BFBranch findAllInContext:[self privateQueueContext]];
}

- (NSArray *)findRegions {
    return [BFRegion findAllInContext:[self privateQueueContext]];
}


#pragma mark - Application Info

- (NSArray *)findInfoPages {
    return [BFInfoPage findAllInContext:[self privateQueueContext]];
}

- (BFInfoPage *)findInfoPageWithIdentification:(NSNumber *)identification {
    return [BFInfoPage findFirstByAttribute:@"pageID" withValue:identification inContext:[self privateQueueContext]];
}


#pragma mark - Products & Variants

- (NSArray *)findProductsWithInfo:(BFDataRequestProductInfo *)productInfo {
    NSFetchRequest *request = [BFProduct requestAllWithPredicate:[productInfo dataFetchPredicate]];
    return [BFProduct MR_executeFetchRequest:[request requestWithProductInfo:productInfo] inContext:[self privateQueueContext]];
}

- (BFProduct *)findProductWithIdentification:(NSNumber *)identification {
    return [BFProduct findFirstByAttribute:@"productID" withValue:identification inContext:[self privateQueueContext]];
}

- (BFProductVariant *)findProductVariantWithIdentification:(NSNumber *)identification {
    return [BFProductVariant findFirstByAttribute:@"productVariantID" withValue:identification inContext:[self privateQueueContext]];
}

- (NSArray *)findProductVariantColorsForProducts:(NSArray *)products withSizes:(NSArray *)sizes {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY productVariants.product IN %@", products];
    if(sizes) {
        predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(productVariants, $item, $item.size IN %@ AND $item.product IN %@).@count > 0", sizes, products];
    }
    return [BFProductVariantColor findAllSortedBy:@"name" ascending:YES withPredicate:predicate inContext:[self privateQueueContext]];;
}

- (NSArray *)findProductVariantColorsForProductVariants:(NSArray *)productVariants withSizes:(NSArray *)sizes {
    NSArray *filteredProductVariants = productVariants;
    if(sizes) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.size IN %@", sizes];
        filteredProductVariants = [productVariants filteredArrayUsingPredicate:predicate];
    }
    return [filteredProductVariants valueForKeyPath:@"@distinctUnionOfObjects.color"];
}

- (NSArray *)findProductVariantSizesForProducts:(NSArray *)products withColors:(NSArray *)colors {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY productVariants.product IN %@", products];
    if(colors) {
        predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(productVariants, $item, $item.color IN %@ AND $item.product IN %@).@count > 0", colors, products];
    }
    return [BFProductVariantSize findAllWithPredicate:predicate inContext:[self privateQueueContext]];
}

- (NSArray *)findProductVariantSizesForProductVariants:(NSArray *)productVariants withColors:(NSArray *)colors {
    NSArray *filteredProductVariants = productVariants;
    if(colors) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.color IN %@", colors];
        filteredProductVariants = [productVariants filteredArrayUsingPredicate:predicate];
    }
    return [filteredProductVariants valueForKey:@"size"];
}

- (BFProductVariant *)findProductVariantForProduct:(BFProduct *)product withColor:(BFProductVariantColor *)color size:(BFProductVariantSize *)size {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product == %@", product];
    if(color) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"color == %@", color]]];
    }
    if(size) {
        // size is a reserved keyword in core data therefore it must be escaped with #
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"#size == %@", size]]];
    }
    
    return [BFProductVariant findFirstWithPredicate:predicate inContext:[self privateQueueContext]];
}


#pragma mark - Shopping Cart Contents

- (NSArray *)findShoppingCartContents {
    return [BFCartProductItem findAllInContext:[self privateQueueContext]];
}


#pragma mark - Shopping Cart Modification

- (void)addProductVariant:(BFProductVariant *)productVariant toCartWithCartInfo:(BFDataRequestCartProductInfo *)cartInfo {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BFCartProductItem *cartProductItem = [BFCartProductItem MR_createEntityInContext:localContext];
        // attributes
        [cartInfo updateDataModel:&cartProductItem inContext:localContext];
        // relations
        productVariant.inCart = cartProductItem;
        cartProductItem.productVariant = productVariant;
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)updateProductVariant:(BFProductVariant *)productVariant inCartWithCartInfo:(BFDataRequestCartProductInfo *)cartInfo {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        if(productVariant.inCart) {
            BFCartProductItem *cartProductItem = productVariant.inCart;
            // attributes
            [cartInfo updateDataModel:&cartProductItem inContext:localContext];
            // relations
            cartProductItem.productVariant = productVariant;
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)deleteProductVariantInCart:(BFProductVariant *)productVariant {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        if(productVariant.inCart) {
            [productVariant.inCart MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)deleteProductCartItem:(BFCartProductItem *)cartProduct completionBlock:(void(^)(NSError *error))completionBlock {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [cartProduct MR_deleteEntityInContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}



#pragma mark - Shopping Cart Discounts

- (NSArray *)findShoppingCartDiscounts {
    return [BFCartDiscountItem findAllInContext:[self privateQueueContext]];
}

- (void)addDiscountToCartWithInfo:(BFDataRequestCartDiscountInfo *)cartInfo {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BFCartDiscountItem *cartDiscountItem = [BFCartDiscountItem MR_createEntityInContext:localContext];
        // attributes
        [cartInfo updateDataModel:&cartDiscountItem inContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)deleteDiscountInCart:(BFCartDiscountItem *)discountItem completionBlock:(void(^)(NSError *error))completionBlock {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        if(discountItem) {
            [discountItem MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}


#pragma mark - Shopping Cart Delivery Info

- (NSArray *)findShoppingCartDeliveryInfo {
    return [BFCartDelivery findAllInContext:[self privateQueueContext]];
}

- (nullable BFCartDelivery *)findShoppingCartDeliveryWithIdentification:(NSNumber *)identification {
    return [BFCartDelivery findFirstByAttribute:@"deliveryID" withValue:identification inContext:[self privateQueueContext]];
}

- (nullable BFCartDelivery *)findShoppingCartDeliveryWithBranch:(BFBranch *)branch {
    return [BFCartDelivery findFirstByAttribute:@"branch" withValue:branch inContext:[self privateQueueContext]];
}

- (nullable BFCartPayment *)findShoppingCartPaymentWithIdentification:(NSNumber *)identification {
    return [BFCartPayment findFirstByAttribute:@"paymentID" withValue:identification inContext:[self privateQueueContext]];
}

- (nullable NSArray<BFCartPayment *>*)findShoppingCartPaymentsWithDeliveryIdentification:(NSNumber *)deliveryIdentification {
    BFCartDelivery *cartDelivery = [[StorageManager defaultManager] findShoppingCartDeliveryWithIdentification:deliveryIdentification];
    return [cartDelivery.payments allObjects];
}


#pragma mark - Shopping Cart Reservations

- (NSArray *)findReservedProductVariants {
    return [BFCartProductItem findByAttribute:@"isReservation" withValue:@(YES) inContext:[self privateQueueContext]];
}

- (void)deleteReservedProductVariant:(BFProductVariant *)productVariant {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        if(productVariant.inCart) {
            [productVariant.inCart MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}


#pragma mark - Orders & Shipping

- (NSArray *)findShipping {
    return [BFOrderShipping findAll];
}

- (NSArray *)findOrdersWithInfo:(BFDataRequestPagerInfo *)info {
    NSFetchRequest *request = [BFOrder requestAll];
    return [BFOrder MR_executeFetchRequest:[request requestWithPagerInfo:info] inContext:[self privateQueueContext]];
}

- (void)createOrderWithCartShipping:(BFOrderShipping *)shipping payment:(BFCartPayment *)payment orderInfo:(BFDataRequestOrderInfo *)orderInfo {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BFOrder *order = [BFOrder MR_createEntityInContext:localContext];
        // attributes
        [orderInfo updateDataModel:&order inContext:localContext];
        // relations
        order.shipping = shipping;
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}


#pragma mark - Wishlist

- (NSArray *)findWishlistContents {
    return [BFWishlistItem findAllInContext:[self privateQueueContext]];
}

- (void)addProductVariant:(BFProductVariant *)productVariant toWishlistWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BFWishlistItem *wishlistItem = [BFWishlistItem MR_createEntityInContext:localContext];
        // attributes
        wishlistItem.wishlistItemID = wishlistInfo.wishlistID;
        // relations
        wishlistItem.productVariant = productVariant;
        productVariant.inWishlist = wishlistItem;
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)deleteProductVariantInWishlist:(BFProductVariant *)productVariant {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        if(productVariant.inWishlist) {
            [productVariant.inWishlist MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)moveWishlistItem:(BFWishlistItem *)wishlistItem toCartWithCartInfo:(BFDataRequestCartProductInfo *)cartInfo {
    if(wishlistItem.productVariant) {
        BFProductVariant *productVariant = wishlistItem.productVariant;
        [self addProductVariant:productVariant toCartWithCartInfo:cartInfo];
    }
}

- (BOOL)isProductVariantInWishlist:(BFProductVariant *)productVariant {
    return productVariant.inWishlist != nil;
}


#pragma mark - Search Suggestions

- (NSArray *)findSearchSuggestionsWithPrefix:(NSString *)suggestionPrefix limit:(nullable NSNumber *)limit {
    NSPredicate *suggestionPredicate = [NSPredicate predicateWithFormat:@"suggestion BEGINSWITH %@", suggestionPrefix];
    NSFetchRequest *request = [BFSearchSuggestion requestAllWithPredicate:suggestionPredicate];
    if(limit) {
        request.fetchLimit = [limit integerValue];
    }
    return [BFSearchSuggestion MR_executeFetchRequest:request inContext:[self privateQueueContext]];
}

- (BFSearchSuggestion *)findSearchSuggestionWithString:(NSString *)queryString inContext:(NSManagedObjectContext *)context {
    return context ? [BFSearchSuggestion findFirstByAttribute:@"suggestion" withValue:queryString inContext:context] :
    [BFSearchSuggestion findFirstByAttribute:@"suggestion" withValue:queryString];
}

- (void)addSearchSuggestionString:(NSString *)suggestionString {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BFSearchSuggestion *searchSuggestion = [self findSearchSuggestionWithString:suggestionString inContext:localContext];
        // search suggestion does not exist
        if(!searchSuggestion) {
            searchSuggestion = [BFSearchSuggestion MR_createEntityInContext:localContext];
            // attributes
            searchSuggestion.suggestion = suggestionString;
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)addSearchSuggestionsFromCategories:(NSArray<BFCategory *> *)categories {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (BFCategory *category in categories) {
            NSString *suggestionString = category.name;
            BFSearchSuggestion *searchSuggestion = [self findSearchSuggestionWithString:suggestionString inContext:localContext];
            // search suggestion does not exist
            if(!searchSuggestion) {
                searchSuggestion = [BFSearchSuggestion MR_createEntityInContext:localContext];
                // attributes
                searchSuggestion.suggestion = suggestionString;
            }
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)deleteSearchSuggestion:(BFSearchSuggestion *)query {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [query MR_deleteEntityInContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

#pragma mark - Search Queries

- (NSArray *)findLastSearchedQueriesWithLimit:(NSNumber *)limit {
    NSFetchRequest *request = [BFSearchQuery requestAllSortedBy:@"date" ascending:false];
    if(limit) {
        request.fetchLimit = [limit integerValue];
    }
    return [BFSearchQuery MR_executeFetchRequest:request inContext:[self privateQueueContext]];
}

- (NSArray *)findMostSearchedQueriesWithLimit:(NSNumber *)limit minOccurences:(NSNumber *)occurences {
    NSFetchRequest *request = [BFSearchQuery requestAllSortedBy:@"quantity" ascending:false];
    if(occurences) {
        request.predicate = [NSPredicate predicateWithFormat:@"quantity >= %ld", (long)[occurences integerValue]];
    }
    if(limit) {
        request.fetchLimit = [limit integerValue];
    }
    return [BFSearchQuery MR_executeFetchRequest:request inContext:[self privateQueueContext]];
}

- (BFSearchQuery *)findSearchQueryWithQueryString:(NSString *)queryString inContext:(NSManagedObjectContext *)context {
    return context ? [BFSearchQuery findFirstByAttribute:@"query" withValue:queryString inContext:context] :
                     [BFSearchQuery findFirstByAttribute:@"query" withValue:queryString];
}

- (void)addSearchQueryString:(NSString *)queryString {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BFSearchQuery *searchQuery = [self findSearchQueryWithQueryString:queryString inContext:localContext];
    
        // search query does not exist
        if(!searchQuery) {
            searchQuery = [BFSearchQuery MR_createEntityInContext:localContext];
            // attributes
            searchQuery.query = queryString;
            searchQuery.quantity = @1;
        }
        // search query exists
        else {
            // attributes
            searchQuery.quantity = @([searchQuery.quantity integerValue]+1);
        }
        // current search date
        searchQuery.date = [NSDate date];
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)deleteSearchQuery:(BFSearchQuery *)query {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [query MR_deleteEntityInContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
    }];
}


#pragma mark - Translations

- (BFTranslation *)findTranslationWithKey:(NSString *)key {
    return [self findTranslationWithLanguage:[[BFAppPreferences sharedPreferences]selectedLanguage] key:key];
}

- (BFTranslation *)findTranslationWithLanguage:(NSString *)language key:(NSString *)key {
    return [BFTranslation findFirstWithPredicate:[NSPredicate predicateWithFormat:@"language = %@ AND stringID = %@", language, key] inContext:[self privateQueueContext]];
}

- (NSString *)findTranslationStringWithKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    return [self findTranslationStringWithLanguage:[[BFAppPreferences sharedPreferences]selectedLanguage] key:key defaultValue:defaultValue];
}

- (NSString *)findTranslationStringWithLanguage:(NSString *)language key:(NSString *)key defaultValue:(NSString *)defaultValue {
    if(key) {
        BFTranslation *translation = [self findTranslationWithLanguage:language key:key];
        if (translation) {
            NSString *translationString = translation.value;
            return translationString ?: @"";
        }
    }
    
    return NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], defaultValue, nil) ?: @"";
}


@end



