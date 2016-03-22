//
//  BFCartDiscountItem+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFCartDiscountItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCartDiscountItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *discountID;
@property (nullable, nonatomic, retain) NSNumber *minCartAmount;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *value;
@property (nullable, nonatomic, retain) NSString *valueFormatted;
@property (nullable, nonatomic, retain) BFCart *cart;

@end

NS_ASSUME_NONNULL_END
