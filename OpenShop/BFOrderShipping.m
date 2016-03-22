//
//  BFOrderShipping.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderShipping.h"
#import "BFOrder.h"



/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFOrderShippingCurrencyPropertyName       = @"currency";
static NSString *const BFOrderShippingNamePropertyName           = @"name";
static NSString *const BFOrderShippingPricePropertyName          = @"price";
static NSString *const BFOrderShippingPriceFormattedPropertyName = @"priceFormatted";
static NSString *const BFOrderShippingShippingIDPropertyName     = @"shippingID";
static NSString *const BFOrderShippingPersonalPickupPropertyName = @"personalPickup";
static NSString *const BFOrderShippingMinCartAmountPropertyName  = @"minCartAmount";


/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFOrderShippingCurrencyPropertyJSONMapping       = @"shipping_currency";
static NSString *const BFOrderShippingNamePropertyJSONMapping           = @"shipping_name";
static NSString *const BFOrderShippingPricePropertyJSONMapping          = @"shipping_price";
static NSString *const BFOrderShippingPriceFormattedPropertyJSONMapping = @"shipping_price_formatted";
static NSString *const BFOrderShippingShippingIDPropertyJSONMapping     = @"shipping_id";
static NSString *const BFOrderShippingPersonalPickupPropertyJSONMapping = @"shipping_personal_pickup";
static NSString *const BFOrderShippingMinCartAmountPropertyJSONMapping  = @"shipping_min_cart_amount";



@implementation BFOrderShipping


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFOrderShippingCurrencyPropertyName       : BFOrderShippingCurrencyPropertyJSONMapping,
             BFOrderShippingNamePropertyName           : BFOrderShippingNamePropertyJSONMapping,
             BFOrderShippingPricePropertyName          : BFOrderShippingPricePropertyJSONMapping,
             BFOrderShippingPriceFormattedPropertyName : BFOrderShippingPriceFormattedPropertyJSONMapping,
             BFOrderShippingShippingIDPropertyName     : BFOrderShippingShippingIDPropertyJSONMapping,
             BFOrderShippingPersonalPickupPropertyName : BFOrderShippingPersonalPickupPropertyJSONMapping,
             BFOrderShippingMinCartAmountPropertyName  : BFOrderShippingMinCartAmountPropertyJSONMapping,
             };
}


@end
