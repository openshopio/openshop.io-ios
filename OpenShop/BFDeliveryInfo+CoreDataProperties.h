//
//  BFDeliveryInfo+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 27.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFDeliveryInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFDeliveryInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<BFCartDelivery *> *personalPickupArray;
@property (nullable, nonatomic, retain) NSSet<BFCartDelivery *> *shippingArray;

@end

@interface BFDeliveryInfo (CoreDataGeneratedAccessors)

- (void)addPersonalPickupArrayObject:(BFCartDelivery *)value;
- (void)removePersonalPickupArrayObject:(BFCartDelivery *)value;
- (void)addPersonalPickupArray:(NSSet<BFCartDelivery *> *)values;
- (void)removePersonalPickupArray:(NSSet<BFCartDelivery *> *)values;

- (void)addShippingArrayObject:(BFCartDelivery *)value;
- (void)removeShippingArrayObject:(BFCartDelivery *)value;
- (void)addShippingArray:(NSSet<BFCartDelivery *> *)values;
- (void)removeShippingArray:(NSSet<BFCartDelivery *> *)values;

@end

NS_ASSUME_NONNULL_END
