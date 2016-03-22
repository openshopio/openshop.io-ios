//
//  BFCartPayment+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCartPayment.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCartPayment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *paymentDescription;
@property (nullable, nonatomic, retain) NSNumber *paymentID;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *priceFormatted;
@property (nullable, nonatomic, retain) NSString *totalPrice;
@property (nullable, nonatomic, retain) NSString *totalPriceFormatted;
@property (nullable, nonatomic, retain) NSSet<BFCartDelivery *> *delivery;

@end

@interface BFCartPayment (CoreDataGeneratedAccessors)

- (void)addDeliveryObject:(BFCartDelivery *)value;
- (void)removeDeliveryObject:(BFCartDelivery *)value;
- (void)addDelivery:(NSSet<BFCartDelivery *> *)values;
- (void)removeDelivery:(NSSet<BFCartDelivery *> *)values;

@end

NS_ASSUME_NONNULL_END
