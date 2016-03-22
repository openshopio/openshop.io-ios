//
//  BFAPIRequestOrderInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFAPIRequestOrderInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFAPIRequestOrderInfoShippingIDPropertyName             = @"shippingID";
static NSString *const BFAPIRequestOrderInfoPaymentIDPropertyName              = @"paymentID";
static NSString *const BFAPIRequestOrderInfoNamePropertyName                   = @"name";
static NSString *const BFAPIRequestOrderInfoEmailPropertyName                  = @"email";
static NSString *const BFAPIRequestOrderInfoPhonePropertyName                  = @"phone";
static NSString *const BFAPIRequestOrderInfoAddressStreetPropertyName          = @"addressStreet";
static NSString *const BFAPIRequestOrderInfoAddressHouseNumberPropertyName     = @"addressHouseNumber";
static NSString *const BFAPIRequestOrderInfoAddressCityPropertyName            = @"addressCity";
static NSString *const BFAPIRequestOrderInfoAddressPostalCodePropertyName      = @"addressPostalCode";
static NSString *const BFAPIRequestOrderInfoAddressCountryPropertyName         = @"addressCountry";
static NSString *const BFAPIRequestOrderInfoNotePropertyName                   = @"note";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFAPIRequestOrderInfoShippingIDPropertyJSONMapping             = @"shipping_type";
static NSString *const BFAPIRequestOrderInfoPaymentIDPropertyJSONMapping              = @"payment_type";
static NSString *const BFAPIRequestOrderInfoNamePropertyJSONMapping                   = @"name";
static NSString *const BFAPIRequestOrderInfoEmailPropertyJSONMapping                  = @"email";
static NSString *const BFAPIRequestOrderInfoPhonePropertyJSONMapping                  = @"phone";
static NSString *const BFAPIRequestOrderInfoAddressStreetPropertyJSONMapping          = @"street";
static NSString *const BFAPIRequestOrderInfoAddressHouseNumberPropertyJSONMapping     = @"house_number";
static NSString *const BFAPIRequestOrderInfoAddressCityPropertyJSONMapping            = @"city";
static NSString *const BFAPIRequestOrderInfoAddressPostalCodePropertyJSONMapping      = @"zip";
static NSString *const BFAPIRequestOrderInfoAddressCountryPropertyJSONMapping         = @"country";
static NSString *const BFAPIRequestOrderInfoNotePropertyJSONMapping                   = @"note";


@interface BFAPIRequestOrderInfo ()

@end


@implementation BFAPIRequestOrderInfo


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFAPIRequestOrderInfoShippingIDPropertyName             : BFAPIRequestOrderInfoShippingIDPropertyJSONMapping,
             BFAPIRequestOrderInfoPaymentIDPropertyName              : BFAPIRequestOrderInfoPaymentIDPropertyJSONMapping,
             BFAPIRequestOrderInfoNamePropertyName                   : BFAPIRequestOrderInfoNamePropertyJSONMapping,
             BFAPIRequestOrderInfoEmailPropertyName                  : BFAPIRequestOrderInfoEmailPropertyJSONMapping,
             BFAPIRequestOrderInfoPhonePropertyName                  : BFAPIRequestOrderInfoPhonePropertyJSONMapping,
             BFAPIRequestOrderInfoAddressStreetPropertyName          : BFAPIRequestOrderInfoAddressStreetPropertyJSONMapping,
             BFAPIRequestOrderInfoAddressHouseNumberPropertyName     : BFAPIRequestOrderInfoAddressHouseNumberPropertyJSONMapping,
             BFAPIRequestOrderInfoAddressCityPropertyName            : BFAPIRequestOrderInfoAddressCityPropertyJSONMapping,
             BFAPIRequestOrderInfoAddressPostalCodePropertyName      : BFAPIRequestOrderInfoAddressPostalCodePropertyJSONMapping,
             BFAPIRequestOrderInfoAddressCountryPropertyName         : BFAPIRequestOrderInfoAddressCountryPropertyJSONMapping,
             BFAPIRequestOrderInfoNotePropertyName                   : BFAPIRequestOrderInfoNotePropertyJSONMapping,
             };
}



@end



