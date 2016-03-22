//
//  BFBranchOpeningHours+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 25.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFBranchOpeningHours.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFBranchOpeningHours (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *day;
@property (nullable, nonatomic, retain) NSString *opening;
@property (nullable, nonatomic, retain) NSNumber *openingHoursID;
@property (nullable, nonatomic, retain) NSSet<BFBranch *> *branch;

@end

@interface BFBranchOpeningHours (CoreDataGeneratedAccessors)

- (void)addBranchObject:(BFBranch *)value;
- (void)removeBranchObject:(BFBranch *)value;
- (void)addBranch:(NSSet<BFBranch *> *)values;
- (void)removeBranch:(NSSet<BFBranch *> *)values;

@end

NS_ASSUME_NONNULL_END
