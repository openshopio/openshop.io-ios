//
//  BFCart+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 24.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFCart.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCart (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cartID;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSNumber *productCount;
@property (nullable, nonatomic, retain) NSNumber *totalPrice;
@property (nullable, nonatomic, retain) NSString *totalPriceFormatted;
@property (nullable, nonatomic, retain) NSOrderedSet<BFCartDiscountItem *> *discounts;
@property (nullable, nonatomic, retain) NSOrderedSet<BFCartProductItem *> *products;

@end

@interface BFCart (CoreDataGeneratedAccessors)

- (void)insertObject:(BFCartDiscountItem *)value inDiscountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDiscountsAtIndex:(NSUInteger)idx;
- (void)insertDiscounts:(NSArray<BFCartDiscountItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDiscountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDiscountsAtIndex:(NSUInteger)idx withObject:(BFCartDiscountItem *)value;
- (void)replaceDiscountsAtIndexes:(NSIndexSet *)indexes withDiscounts:(NSArray<BFCartDiscountItem *> *)values;
- (void)addDiscountsObject:(BFCartDiscountItem *)value;
- (void)removeDiscountsObject:(BFCartDiscountItem *)value;
- (void)addDiscounts:(NSOrderedSet<BFCartDiscountItem *> *)values;
- (void)removeDiscounts:(NSOrderedSet<BFCartDiscountItem *> *)values;

- (void)insertObject:(BFCartProductItem *)value inProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductsAtIndex:(NSUInteger)idx;
- (void)insertProducts:(NSArray<BFCartProductItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductsAtIndex:(NSUInteger)idx withObject:(BFCartProductItem *)value;
- (void)replaceProductsAtIndexes:(NSIndexSet *)indexes withProducts:(NSArray<BFCartProductItem *> *)values;
- (void)addProductsObject:(BFCartProductItem *)value;
- (void)removeProductsObject:(BFCartProductItem *)value;
- (void)addProducts:(NSOrderedSet<BFCartProductItem *> *)values;
- (void)removeProducts:(NSOrderedSet<BFCartProductItem *> *)values;

@end

NS_ASSUME_NONNULL_END
