//
//  BFProductVariant+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFProductVariant.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFProductVariant (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) id images;
@property (nullable, nonatomic, retain) NSNumber *productVariantID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *priceFormatted;
@property (nullable, nonatomic, retain) NSNumber *discountPrice;
@property (nullable, nonatomic, retain) NSString *discountPriceFormatted;
@property (nullable, nonatomic, retain) NSNumber *category;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSString *productVariantDescription;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSNumber *productID;
@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) BFProductVariantColor *color;
@property (nullable, nonatomic, retain) BFCartProductItem *inCart;
@property (nullable, nonatomic, retain) NSSet<BFOrderItem *> *inOrders;
@property (nullable, nonatomic, retain) BFWishlistItem *inWishlist;
@property (nullable, nonatomic, retain) BFProduct *product;
@property (nullable, nonatomic, retain) BFProductVariantSize *size;

@end

@interface BFProductVariant (CoreDataGeneratedAccessors)

- (void)addInOrdersObject:(BFOrderItem *)value;
- (void)removeInOrdersObject:(BFOrderItem *)value;
- (void)addInOrders:(NSSet<BFOrderItem *> *)values;
- (void)removeInOrders:(NSSet<BFOrderItem *> *)values;

@end

NS_ASSUME_NONNULL_END
