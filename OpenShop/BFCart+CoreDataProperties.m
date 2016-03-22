//
//  BFCart+CoreDataProperties.m
//  OpenShop
//
//  Created by Petr Škorňok on 24.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFCart+CoreDataProperties.h"

@implementation BFCart (CoreDataProperties)

@dynamic cartID;
@dynamic currency;
@dynamic productCount;
@dynamic totalPrice;
@dynamic totalPriceFormatted;
@dynamic discounts;
@dynamic products;

@end
