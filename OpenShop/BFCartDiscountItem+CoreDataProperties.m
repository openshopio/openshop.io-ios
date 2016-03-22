//
//  BFCartDiscountItem+CoreDataProperties.m
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFCartDiscountItem+CoreDataProperties.h"

@implementation BFCartDiscountItem (CoreDataProperties)

@dynamic discountID;
@dynamic minCartAmount;
@dynamic name;
@dynamic quantity;
@dynamic type;
@dynamic value;
@dynamic valueFormatted;
@dynamic cart;

@end
