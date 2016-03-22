//
//  BFDataRequestOrderInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFDataRequestOrderInfo.h"
#import "BFOrder.h"
#import "BFOrderItem.h"
#import "BFProductVariant.h"
#import "StorageManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>
#import <MagicalRecord/MagicalRecordShorthandMethodAliases.h>

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFDataRequestOrderInfoRemoteIDPropertyName               = @"remoteID";
static NSString *const BFDataRequestOrderInfoStatusPropertyName                 = @"status";
static NSString *const BFDataRequestOrderInfoTotalPricePropertyName             = @"totalPrice";
static NSString *const BFDataRequestOrderInfoTotalPriceFormattedPropertyName    = @"totalPriceFormatted";
static NSString *const BFDataRequestOrderInfoOrderItemsFormattedPropertyName    = @"orderItems";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFDataRequestOrderInfoRemoteIDPropertyJSONMapping               = @"remote_id";
static NSString *const BFDataRequestOrderInfoStatusPropertyJSONMapping                 = @"status";
static NSString *const BFDataRequestOrderInfoTotalPricePropertyJSONMapping             = @"total_price";
static NSString *const BFDataRequestOrderInfoTotalPriceFormattedPropertyJSONMapping    = @"total_price_formatted";
static NSString *const BFDataRequestOrderInfoOrderItemsFormattedPropertyJSONMapping    = @"items";

@interface BFDataRequestOrderInfo ()

@end


@implementation BFDataRequestOrderInfo


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFDataRequestOrderInfoRemoteIDPropertyName               : BFDataRequestOrderInfoRemoteIDPropertyJSONMapping,
             BFDataRequestOrderInfoStatusPropertyName                 : BFDataRequestOrderInfoStatusPropertyJSONMapping,
             BFDataRequestOrderInfoTotalPricePropertyName             : BFDataRequestOrderInfoTotalPricePropertyJSONMapping,
             BFDataRequestOrderInfoTotalPriceFormattedPropertyName    : BFDataRequestOrderInfoTotalPriceFormattedPropertyJSONMapping,
             BFDataRequestOrderInfoOrderItemsFormattedPropertyName    : BFDataRequestOrderInfoOrderItemsFormattedPropertyJSONMapping,
             };
}

+ (NSValueTransformer *)orderItemsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *orderItems, BOOL *success, NSError *__autoreleasing *error) {
        if(orderItems) {
            NSMutableArray<BFDataRequestOrderItemInfo *> *transformedOrderItems = [[NSMutableArray alloc]init];
            for (NSDictionary *orderItem in orderItems) {
                BFDataRequestOrderItemInfo *dataItem = [MTLJSONAdapter modelOfClass:BFDataRequestOrderItemInfo.class fromJSONDictionary:orderItem error:error];
                if(dataItem) {
                    [transformedOrderItems addObject:dataItem];
                }
            }
            return transformedOrderItems;
        }
        return nil;
    } reverseBlock:^id(NSArray<BFDataRequestOrderItemInfo *> *orderItems, BOOL *success, NSError *__autoreleasing *error) {
        if(orderItems) {
            NSMutableArray<NSDictionary *> *transformedOrderItems = [[NSMutableArray alloc]init];
            for (BFDataRequestOrderItemInfo *orderItem in orderItems) {
                NSDictionary *dataItem = [MTLJSONAdapter JSONDictionaryFromModel:orderItem error:error];
                if(dataItem) {
                    [transformedOrderItems addObject:dataItem];
                }
            }
            return transformedOrderItems;
        }
        return nil;
    }];
}


#pragma mark - BFDataStorageAccessing Protocol

- (void)updateDataModel:(NSManagedObject *__autoreleasing *)model inContext:(NSManagedObjectContext *)context {
    if([(*model) isKindOfClass:[BFOrder class]]) {
        BFOrder *order = (BFOrder *)(*model);
        // order attributes
        order.orderID = self.orderID ?: order.orderID;
        order.orderRemoteID = self.remoteID ?: order.orderRemoteID;
        order.status = self.status ?: order.status;
        order.totalPrice = self.totalPrice ?: order.totalPrice;
        order.totalPriceFormatted = self.totalPriceFormatted ?: order.totalPriceFormatted;
        order.clientName = self.name ?: order.clientName;
        
        // order items
        NSMutableArray *orderItemModels = [[NSMutableArray alloc]init];
        for (BFDataRequestOrderItemInfo *orderItem in self.orderItems) {
            BFOrderItem *orderItemModel = [BFOrderItem MR_createEntityInContext:context];
            // attributes
            [orderItem updateDataModel:&orderItemModel inContext:context];
            // relations
            orderItemModel.inOrder = order;
            [orderItemModels addObject:orderItemModel];
        }
        [order setOrderItems:[NSSet setWithArray:orderItemModels]];
    }
}

@end



