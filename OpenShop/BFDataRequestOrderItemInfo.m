//
//  BFDataRequestOrderItemInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataRequestOrderItemInfo.h"
#import "BFOrderItem.h"
#import "BFProductVariant.h"
#import "StorageManager.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFDataRequestOrderItemInfoOrderItemIDPropertyName      = @"orderItemID";
static NSString *const BFDataRequestOrderItemInfoQuantityPropertyName         = @"quantity";
static NSString *const BFDataRequestOrderItemInfoPricePropertyName            = @"price";
static NSString *const BFDataRequestOrderItemInfoPriceFormattedPropertyName   = @"priceFormatted";
static NSString *const BFDataRequestOrderItemInfoProductVariantIDPropertyName = @"productVariantID";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFDataRequestOrderItemInfoOrderItemIDPropertyJSONMapping      = @"id";
static NSString *const BFDataRequestOrderItemInfoQuantityPropertyJSONMapping         = @"quantity";
static NSString *const BFDataRequestOrderItemInfoPricePropertyJSONMapping            = @"price";
static NSString *const BFDataRequestOrderItemInfoPriceFormattedPropertyJSONMapping   = @"price_formatted";
static NSString *const BFDataRequestOrderItemInfoProductVariantIDPropertyJSONMapping = @"variant.id";

@interface BFDataRequestOrderItemInfo ()

@end


@implementation BFDataRequestOrderItemInfo


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFDataRequestOrderItemInfoOrderItemIDPropertyName      : BFDataRequestOrderItemInfoOrderItemIDPropertyJSONMapping,
             BFDataRequestOrderItemInfoQuantityPropertyName         : BFDataRequestOrderItemInfoQuantityPropertyJSONMapping,
             BFDataRequestOrderItemInfoPricePropertyName            : BFDataRequestOrderItemInfoPricePropertyJSONMapping,
             BFDataRequestOrderItemInfoPriceFormattedPropertyName   : BFDataRequestOrderItemInfoPriceFormattedPropertyJSONMapping,
             BFDataRequestOrderItemInfoProductVariantIDPropertyName : BFDataRequestOrderItemInfoProductVariantIDPropertyJSONMapping,
             };
}


#pragma mark - BFDataStorageAccessing Protocol

- (void)updateDataModel:(NSManagedObject *__autoreleasing *)model inContext:(NSManagedObjectContext *)context {
    if([(*model) isKindOfClass:[BFOrderItem class]]) {
        BFOrderItem *orderItem = (BFOrderItem *)(*model);
        // order item attributes
        if(self.productVariantID) {
            NSNumber *productVariantID = self.productVariantID;
            BFProductVariant *productVariant = [[StorageManager defaultManager]findProductVariantWithIdentification:productVariantID];
            if(productVariant) {
                orderItem.quantity = self.quantity ?: orderItem.quantity;
                orderItem.price = self.price ?: orderItem.price;
                orderItem.priceFormatted = self.priceFormatted ?: orderItem.priceFormatted;
                orderItem.productVariant = productVariant;
            }
        }
    }
}


@end



