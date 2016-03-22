//
//  BFCartProductItem+CoreDataProperties.m
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFCartProductItem+CoreDataProperties.h"

@implementation BFCartProductItem (CoreDataProperties)

@dynamic cartItemID;
@dynamic expiration;
@dynamic isReservation;
@dynamic quantity;
@dynamic remoteID;
@dynamic totalPrice;
@dynamic totalPriceFormatted;
@dynamic cart;
@dynamic productVariant;

@end
