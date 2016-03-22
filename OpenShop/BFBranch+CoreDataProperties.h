//
//  BFBranch+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 25.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFBranch.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFBranch (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *branchID;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSSet<BFCartDelivery *> *delivery;
@property (nullable, nonatomic, retain) NSSet<BFBranchTransport *> *transports;
@property (nullable, nonatomic, retain) NSOrderedSet<BFBranchOpeningHours *> *openingHours;

@end

@interface BFBranch (CoreDataGeneratedAccessors)

- (void)addDeliveryObject:(BFCartDelivery *)value;
- (void)removeDeliveryObject:(BFCartDelivery *)value;
- (void)addDelivery:(NSSet<BFCartDelivery *> *)values;
- (void)removeDelivery:(NSSet<BFCartDelivery *> *)values;

- (void)addTransportsObject:(BFBranchTransport *)value;
- (void)removeTransportsObject:(BFBranchTransport *)value;
- (void)addTransports:(NSSet<BFBranchTransport *> *)values;
- (void)removeTransports:(NSSet<BFBranchTransport *> *)values;

- (void)insertObject:(BFBranchOpeningHours *)value inOpeningHoursAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOpeningHoursAtIndex:(NSUInteger)idx;
- (void)insertOpeningHours:(NSArray<BFBranchOpeningHours *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOpeningHoursAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOpeningHoursAtIndex:(NSUInteger)idx withObject:(BFBranchOpeningHours *)value;
- (void)replaceOpeningHoursAtIndexes:(NSIndexSet *)indexes withOpeningHours:(NSArray<BFBranchOpeningHours *> *)values;
- (void)addOpeningHoursObject:(BFBranchOpeningHours *)value;
- (void)removeOpeningHoursObject:(BFBranchOpeningHours *)value;
- (void)addOpeningHours:(NSOrderedSet<BFBranchOpeningHours *> *)values;
- (void)removeOpeningHours:(NSOrderedSet<BFBranchOpeningHours *> *)values;

@end

NS_ASSUME_NONNULL_END
