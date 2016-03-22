//
//  BFCartProductItem+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFCartProductItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCartProductItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cartItemID;
@property (nullable, nonatomic, retain) NSDate *expiration;
@property (nullable, nonatomic, retain) NSNumber *isReservation;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSNumber *totalPrice;
@property (nullable, nonatomic, retain) NSString *totalPriceFormatted;
@property (nullable, nonatomic, retain) BFCart *cart;
@property (nullable, nonatomic, retain) BFProductVariant *productVariant;

@end

NS_ASSUME_NONNULL_END
