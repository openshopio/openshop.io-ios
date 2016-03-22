//
//  BFOrderShipping+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderShipping.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFOrderShipping (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *priceFormatted;
@property (nullable, nonatomic, retain) NSNumber *shippingID;
@property (nullable, nonatomic, retain) NSNumber *personalPickup;
@property (nullable, nonatomic, retain) NSNumber *minCartAmount;
@property (nullable, nonatomic, retain) NSSet<BFOrder *> *orders;

@end

@interface BFOrderShipping (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(BFOrder *)value;
- (void)removeOrdersObject:(BFOrder *)value;
- (void)addOrders:(NSSet<BFOrder *> *)values;
- (void)removeOrders:(NSSet<BFOrder *> *)values;

@end

NS_ASSUME_NONNULL_END
