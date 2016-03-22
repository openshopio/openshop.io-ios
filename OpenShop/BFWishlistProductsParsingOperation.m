//
//  BFWishlistProductsParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFWishlistProductsParsingOperation.h"
#import "BFProductParsedResult.h"
#import "NSArray+BFObjectFiltering.h"
#import "BFProductVariant.h"

/**
 * The wishlist item element key path in a raw JSON data.
 */
static NSString *const BFWishlistItemParsingRootElementKey = @"items";
/**
 * The wishlist item identification element key path in a raw JSON data.
 */
static NSString *const BFWishlistItemParsingIDElementKey = @"id";
/**
 * The wishlist item product variant element key path in a raw JSON data.
 */
static NSString *const BFWishlistItemParsingProductVariantElementKey = @"variant";


@interface BFWishlistProductsParsingOperation ()


@end


@implementation BFWishlistProductsParsingOperation


#pragma mark - Parsing

- (void)main {
    // wishlist items
    NSArray *wishlistItemsArray = (NSArray *)[self.rawData valueForKeyPath:BFWishlistItemParsingRootElementKey];
    if(wishlistItemsArray) {
        // wishlist items parsing
        for (id wishlistItemElem in wishlistItemsArray) {
            // stop parsing if the operation has been cancelled
            if (self.isCancelled) {
                break;
            }
            // parse wishlist item
            if([wishlistItemElem isKindOfClass:[NSDictionary class]]) {
                NSNumber *wishlistItemID = [wishlistItemElem objectForKey:BFWishlistItemParsingIDElementKey];
                BFWishlistItem *wishlistItem = [self findWishlistItemWithID:wishlistItemID];
            
                // if wishlist item exists parse its product
                if(wishlistItem && wishlistItem.productVariant) {
                    id wishlistItemProductVariantElem = [wishlistItemElem objectForKey:BFWishlistItemParsingProductVariantElementKey];
                    if(wishlistItemProductVariantElem && [wishlistItemProductVariantElem isKindOfClass:[NSDictionary class]]) {
                        // product data model
                        BFProduct *product = [BFProductParsedResult dataModelFromDictionary:wishlistItemProductVariantElem];
                        // relations
                        wishlistItem.productVariant.product = product;
                        [product addProductVariantsObject:(BFProductVariant *)wishlistItem.productVariant];
                    }
                }
            }
        }
      
        
        // save records
        NSError *error;
        if ([self.managedObjectContext save:&error]) {
            if(self.completion) {
                self.completion(self.records, nil, nil);
            }
        }
        else {
            if(self.completion) {
                self.completion(nil, nil, error);
            }
        }
    }
    else {
        if(self.completion) {
            self.completion(nil, nil, [BFError errorWithCode:BFErrorCodeNoData]);
        }
    }
    
}


- (BFWishlistItem *)findWishlistItemWithID:(NSNumber *)wishlistItemID {
    if(self.records) {
        return (BFWishlistItem *)[self.records BFN_objectForAttributeBindings:@{@"wishlistItemID" : wishlistItemID}];
    }
    return nil;
}


@end



