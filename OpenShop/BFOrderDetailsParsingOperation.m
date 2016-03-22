//
//  BFOrderDetailsParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderDetailsParsingOperation.h"
#import "BFProductParsedResult.h"
#import "NSArray+BFObjectFiltering.h"
#import "BFProductVariant.h"
#import "BFOrder.h"
#import "BFOrderItem.h"
#import "BFOrderShippingParsedResult.h"
#import "BFOrderShipping.h"

/**
 * The order items element key path in a raw JSON data.
 */
static NSString *const BFOrderItemsParsingRootElementKey          = @"items";
/**
 * The order identification element key path in a raw JSON data.
 */
static NSString *const BFOrderParsingIDElementKey                 = @"id";
/**
 * The order item product variant element key path in a raw JSON data.
 */
static NSString *const BFOrderItemParsingProductVariantElementKey = @"variant";


@interface BFOrderDetailsParsingOperation ()


@end


@implementation BFOrderDetailsParsingOperation


#pragma mark - Parsing

- (void)main {
    if([self.rawData isKindOfClass:[NSDictionary class]]) {
        // order items
        NSArray *orderItemsArray = (NSArray *)[self.rawData valueForKeyPath:BFOrderItemsParsingRootElementKey];
        if(orderItemsArray) {
            // order items parsing
            for (id orderItemElem in orderItemsArray) {
                // stop parsing if the operation has been cancelled
                if (self.isCancelled) {
                    break;
                }
                // parse order item
                if([orderItemElem isKindOfClass:[NSDictionary class]]) {
                    NSNumber *orderItemID = [orderItemElem objectForKey:BFOrderParsingIDElementKey];
                    BFOrderItem *orderItem = [self findOrderItemWithID:orderItemID];
                
                    // if order item exists parse its product
                    if(orderItem && orderItem.productVariant) {
                        id orderItemProductVariantElem = [orderItemElem objectForKey:BFOrderItemParsingProductVariantElementKey];
                        if(orderItemProductVariantElem && [orderItemProductVariantElem isKindOfClass:[NSDictionary class]]) {
                            // product data model
                            BFProduct *product = [BFProductParsedResult dataModelFromDictionary:orderItemProductVariantElem];
                            // relations
                            orderItem.productVariant.product = product;
                            [product addProductVariantsObject:(BFProductVariant *)orderItem.productVariant];
                        }
                    }
                }
            }
        }
        
        // order shipping info
        BFOrderShipping *orderShipping = [BFOrderShippingParsedResult dataModelFromDictionary:(NSDictionary *)self.rawData];
        if(orderShipping && self.records && self.records.count) {
            // relations
            BFOrder *order = [self.records firstObject];
            order.shipping = orderShipping;
            [orderShipping addOrdersObject:order];
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

- (BFOrderItem *)findOrderItemWithID:(NSNumber *)orderItemID {
    if(self.records) {
        BFOrder *order = [self.records firstObject];
        if(order && order.orderItems) {
            return (BFOrderItem *)[[order.orderItems allObjects] BFN_objectForAttributeBindings:@{@"orderItemID" : orderItemID}];
        }
    }
    return nil;
}


@end



