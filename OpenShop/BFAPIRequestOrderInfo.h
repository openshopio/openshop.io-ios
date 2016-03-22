//
//  BFAPIRequestOrderInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFDataRequestPagerInfo.h"

@class BFCartDelivery;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAPIRequestOrderInfo` encapsulates information used when accessing remote API with
 * order requests. It is a subclass of `BFDataRequestPagerInfo` which adds ability
 * to specify pagination info. It contains order details information, order shipping
 * and payment info.
 */
@interface BFAPIRequestOrderInfo : BFDataRequestPagerInfo
/**
 * Order identification.
 */
@property (strong, nullable) NSNumber *orderID;
/**
 * Order shipping identification.
 */
@property (strong, nullable) NSNumber *shippingID;
/**
 * Order payment identification.
 */
@property (strong, nullable) NSNumber *paymentID;
/**
 * Order receiver name and surname.
 */
@property (copy, nullable) NSString *name;
/**
 * Order receiver e-mail address.
 */
@property (copy, nullable) NSString *email;
/**
 * Order receiver telephone number.
 */
@property (copy, nullable) NSString *phone;
/**
 * Order receiver street address.
 */
@property (copy, nullable) NSString *addressStreet;
/**
 * Order receiver address house number.
 */
@property (copy, nullable) NSString *addressHouseNumber;
/**
 * Order receiver address city.
 */
@property (copy, nullable) NSString *addressCity;
/**
 * Order receiver address postal code.
 */
@property (copy, nullable) NSString *addressPostalCode;
/**
 * Order receiver address country code.
 */
@property (copy, nullable) NSString *addressCountry;
/**
 * Order additional text note.
 */
@property (copy, nullable) NSString *note;


@end

NS_ASSUME_NONNULL_END
