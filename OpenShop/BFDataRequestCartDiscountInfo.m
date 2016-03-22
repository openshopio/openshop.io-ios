//
//  BFDataRequestCartDiscountInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataRequestCartDiscountInfo.h"
#import "BFCartDiscountItem.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */

static NSString *const BFDataRequestCartDiscountInfoMinCartAmountPropertyName  = @"minCartAmount";
static NSString *const BFDataRequestCartDiscountInfoNamePropertyName           = @"name";
static NSString *const BFDataRequestCartDiscountInfoTypePropertyName           = @"type";
static NSString *const BFDataRequestCartDiscountInfoValuePropertyName          = @"value";
static NSString *const BFDataRequestCartDiscountInfoValueFormattedPropertyName = @"valueFormatted";
static NSString *const BFDataRequestCartDiscountInfoQuantityPropertyName = @"quantity";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFDataRequestCartDiscountInfoMinCartAmountPropertyJSONMapping  = @"min_cart_amount";
static NSString *const BFDataRequestCartDiscountInfoNamePropertyJSONMapping           = @"name";
static NSString *const BFDataRequestCartDiscountInfoTypePropertyJSONMapping           = @"type";
static NSString *const BFDataRequestCartDiscountInfoValuePropertyJSONMapping          = @"value";
static NSString *const BFDataRequestCartDiscountInfoValueFormattedPropertyJSONMapping = @"value_formatted";
static NSString *const BFDataRequestCartDiscountInfoQuantityPropertyJSONMapping       = @"quantity";

@implementation BFDataRequestCartDiscountInfo


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *parentKeyPaths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [parentKeyPaths addEntriesFromDictionary:@{
                                               BFDataRequestCartDiscountInfoMinCartAmountPropertyName  : BFDataRequestCartDiscountInfoMinCartAmountPropertyJSONMapping,
                                               BFDataRequestCartDiscountInfoNamePropertyName           : BFDataRequestCartDiscountInfoNamePropertyJSONMapping,
                                               BFDataRequestCartDiscountInfoTypePropertyName           : BFDataRequestCartDiscountInfoTypePropertyJSONMapping,
                                               BFDataRequestCartDiscountInfoValuePropertyName          : BFDataRequestCartDiscountInfoValuePropertyJSONMapping,
                                               BFDataRequestCartDiscountInfoValueFormattedPropertyName : BFDataRequestCartDiscountInfoValueFormattedPropertyJSONMapping,
                                               BFDataRequestCartDiscountInfoQuantityPropertyName       : BFDataRequestCartDiscountInfoQuantityPropertyJSONMapping,
                                               }];
    return parentKeyPaths;
}


#pragma mark - BFDataStorageAccessing Protocol

- (void)updateDataModel:(NSManagedObject *__autoreleasing *)model inContext:(NSManagedObjectContext *)context {
    if([(*model) isKindOfClass:[BFCartDiscountItem class]]) {
        BFCartDiscountItem *discountItem = (BFCartDiscountItem *)(*model);
        // attributes
        discountItem.discountID = self.discountID ?: discountItem.discountID;
        discountItem.minCartAmount = self.minCartAmount ?: discountItem.minCartAmount;
        discountItem.quantity = self.quantity ?: discountItem.quantity;
        discountItem.name = self.name ?: discountItem.name;
        discountItem.type = self.type ?: discountItem.type;
        discountItem.value = self.value ?: discountItem.value;
        discountItem.valueFormatted = self.valueFormatted ?: discountItem.valueFormatted;
    }
}


@end
