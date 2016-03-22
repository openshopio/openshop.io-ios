//
//  BFCartDelivery+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCartDelivery.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCartDelivery (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *currency;
@property (nonnull, nonatomic, retain) NSNumber *deliveryID;
@property (nullable, nonatomic, retain) NSNumber *personalPickup;
@property (nullable, nonatomic, retain) NSNumber *minCartAmount;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *deliveryDescription;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *priceFormatted;
@property (nullable, nonatomic, retain) NSString *totalPrice;
@property (nullable, nonatomic, retain) NSString *totalPriceFormatted;
@property (nullable, nonatomic, retain) BFBranch *branch;
@property (nullable, nonatomic, retain) NSSet<BFCartPayment *> *payments;

@end

@interface BFCartDelivery (CoreDataGeneratedAccessors)

- (void)addPaymentsObject:(BFCartPayment *)value;
- (void)removePaymentsObject:(BFCartPayment *)value;
- (void)addPayments:(NSSet<BFCartPayment *> *)values;
- (void)removePayments:(NSSet<BFCartPayment *> *)values;

@end

NS_ASSUME_NONNULL_END
