//
//  BFBranchTransport+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 25.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFBranchTransport.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFBranchTransport (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iconURL;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *transportID;
@property (nullable, nonatomic, retain) BFBranch *branch;

@end

NS_ASSUME_NONNULL_END
