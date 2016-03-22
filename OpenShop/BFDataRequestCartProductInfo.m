//
//  BFDataRequestCartProductInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataRequestCartProductInfo.h"
#import "BFCartProductItem.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const CartInfoCartRemoteIDPropertyName           = @"cartRemoteID";
static NSString *const CartInfoTotalPricePropertyName             = @"totalPrice";
static NSString *const CartInfoTotalPriceFormattedPropertyName    = @"totalPriceFormatted";
static NSString *const CartInfoIsReservationPropertyName          = @"isReservation";
static NSString *const CartInfoExpirationPropertyName             = @"expiration";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const CartInfoCartRemoteIDPropertyJSONMapping           = @"remote_id";
static NSString *const CartInfoTotalPricePropertyJSONMapping             = @"total_price";
static NSString *const CartInfoTotalPriceFormattedPropertyJSONMapping    = @"total_price_formatted";
static NSString *const CartInfoIsReservationPropertyJSONMapping          = @"is_reservation";
static NSString *const CartInfoExpirationPropertyJSONMapping             = @"expiration";


@implementation BFDataRequestCartProductInfo


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *parentKeyPaths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [parentKeyPaths addEntriesFromDictionary:@{
                                               CartInfoCartRemoteIDPropertyName           : CartInfoCartRemoteIDPropertyJSONMapping,
                                               CartInfoTotalPricePropertyName             : CartInfoTotalPricePropertyJSONMapping,
                                               CartInfoTotalPriceFormattedPropertyName    : CartInfoTotalPriceFormattedPropertyJSONMapping,
                                               CartInfoIsReservationPropertyName          : CartInfoIsReservationPropertyJSONMapping,
                                               CartInfoExpirationPropertyName             : CartInfoExpirationPropertyJSONMapping,
                                               }];
    return parentKeyPaths;
}


#pragma mark - BFDataStorageAccessing Protocol

- (void)updateDataModel:(NSManagedObject *__autoreleasing *)model inContext:(NSManagedObjectContext *)context {
    if([(*model) isKindOfClass:[BFCartProductItem class]]) {
        BFCartProductItem *productItem = (BFCartProductItem *)(*model);
        // attributes
        productItem.cartItemID = self.cartProductID ?: productItem.cartItemID;
        productItem.remoteID = self.cartRemoteID ?: productItem.remoteID;
        productItem.quantity = self.quantity ?: productItem.quantity;
        productItem.totalPrice = self.totalPrice ?: productItem.totalPrice;
        productItem.totalPriceFormatted = self.totalPriceFormatted ?: productItem.totalPriceFormatted;
        productItem.isReservation = self.isReservation ?: productItem.isReservation;
        productItem.expiration = self.expiration ?: productItem.expiration;
    }
}


@end
