//
//  BFOrder+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFOrder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *orderID;
@property (nullable, nonatomic, retain) NSNumber *orderRemoteID;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *totalPriceFormatted;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSNumber *totalPrice;
@property (nullable, nonatomic, retain) NSString *clientName;
@property (nullable, nonatomic, retain) NSSet<BFOrderItem *> *orderItems;
@property (nullable, nonatomic, retain) BFOrderShipping *shipping;

@end

@interface BFOrder (CoreDataGeneratedAccessors)

- (void)addOrderItemsObject:(BFOrderItem *)value;
- (void)removeOrderItemsObject:(BFOrderItem *)value;
- (void)addOrderItems:(NSSet<BFOrderItem *> *)values;
- (void)removeOrderItems:(NSSet<BFOrderItem *> *)values;

@end

NS_ASSUME_NONNULL_END
