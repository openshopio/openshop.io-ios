//
//  BFProductVariant+CoreDataProperties.m
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFProductVariant+CoreDataProperties.h"

@implementation BFProductVariant (CoreDataProperties)

@dynamic code;
@dynamic images;
@dynamic productVariantID;
@dynamic name;
@dynamic price;
@dynamic priceFormatted;
@dynamic discountPrice;
@dynamic discountPriceFormatted;
@dynamic category;
@dynamic currency;
@dynamic productVariantDescription;
@dynamic imageURL;
@dynamic productID;
@dynamic remoteID;
@dynamic color;
@dynamic inCart;
@dynamic inOrders;
@dynamic inWishlist;
@dynamic product;
@dynamic size;

@end
