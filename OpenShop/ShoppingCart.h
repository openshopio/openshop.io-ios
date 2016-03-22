//
//  ShoppingCart.h
//  OpenShop
//
//  Created by Petr Škorňok
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"
#import "BFCartProductItem.h"
#import "BFCartDiscountItem.h"
#import "BFCartDelivery.h"
#import "BFCartPayment.h"
#import "BFDataResponseCartInfo.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * Singleton class representing user's shopping cart.
 */
@interface ShoppingCart : BFJSONSerializableObject <NSCoding>
/**
 * Number of products in the shopping cart.
 */
@property (copy, nullable) NSNumber *productCount;
/**
 * Total price of products in the shopping cart.
 */
@property (copy, nullable) NSNumber *totalPrice;
/**
 * Total price of products in the shopping cart formatted for displaying.
 */
@property (nullable, nonatomic, copy) NSString *totalPriceFormatted;
/**
 * Shopping cart currency.
 */
@property (nullable, nonatomic, copy) NSString *currency;
/**
 * User's address - name.
 */
@property (nullable, nonatomic, copy) NSString *name;
/**
 * User's address - email.
 */
@property (nullable, nonatomic, copy) NSString *email;
/**
 * User's address - street.
 */
@property (nullable, nonatomic, copy) NSString *addressStreet;
/**
 * User's address - house number.
 */
@property (nullable, nonatomic, copy) NSString *addressHouseNumber;
/**
 * User's address - city.
 */
@property (nullable, nonatomic, copy) NSString *addressCity;
/**
 * User's address - postal code.
 */
@property (nullable, nonatomic, copy) NSString *addressPostalCode;
/**
 * User's address - phone number.
 */
@property (nullable, nonatomic, copy) NSString *phone;
/**
 * User's note which comes with the order.
 */
@property (nullable, nonatomic, copy) NSString *note;
/**
 * Available delivery methods.
 */
@property (nullable, nonatomic, copy) NSArray<BFCartDelivery *> *deliveryItems;
/**
 * Selected delivery method.
 */
@property (nullable, nonatomic, strong) BFCartDelivery *selectedDelivery;
/**
 * Available payment methods.
 */
@property (nullable, nonatomic, strong) NSArray<BFCartPayment *> *paymentItems;
/**
 * Selected payment method.
 */
@property (nullable, nonatomic, strong) BFCartPayment *selectedPayment;
/**
 * Products in the shopping cart.
 */
@property (nullable, nonatomic, strong) NSMutableArray<BFCartProductItem *> *products;
/**
 * Discounts in the shopping cart.
 */
@property (nullable, nonatomic, strong) NSMutableArray<BFCartDiscountItem *> *discounts;


/**
 * Class method to access the static shopping cart instance.
 *
 * @return Singleton instance of the `ShoppingCart` class.
 */
+ (ShoppingCart *)sharedCart;

/**
 * Fast refresh shopping cart badge value by calling cart-info.
 */
- (void)refreshCart;
/**
 * Synchronizes shopping cart badge value.
 */
- (void)synchronizeCart;
/**
 * Returns shopping cart contents.
 */
- (void)findShoppingCartContentsCompletion:(nullable void(^)(NSError *))completion;
/**
 * Returns shopping cart info - product count, total price.
 */
- (void)findShoppingCartInfoCompletion:(nullable void(^)(NSError *))completion;

/*
 * Validates `ShoppingCart`. Checks if all the information necessary to complete
 * the order is present.
 */
- (BOOL)isValid;
/*
 * Validates `ShoppingCart` and offers completion handlers if
 * part of the validation fails. The validation is performed at first on shipping and payment
 * and after that on the address fields.
 */
- (BOOL)isValidWithIncompleteShippingPaymentHandler:(void(^)(BFShippingAndPaymentItem))incompleteShippingPaymentHandler
                           incompleteAddressHandler:(void(^)(BFAddressItem))incompleteAddressHandler;

/**
 * Removes product from the cart.
 * @param cartProductItem Product item in the cart to be removed.
 */
- (void)removeCartProductItem:(BFCartProductItem *)cartProductItem didStartCallback:(void(^)())didStartCallback didFinishCallback:(void(^)(NSError *))didFinishCallback;
/**
 * Removes discount from the cart.
 * @param cartDiscountItem Discount item in the cart to be removed.
 */
- (void)removeCartDiscountItem:(BFCartDiscountItem *)cartDiscountItem didStartCallback:(void(^)())didStartCallback didFinishCallback:(void(^)(NSError *))didFinishCallback;

/**
 * Creates order API request and sends it.
 * @param completionBlock Completion block which will be called after the network request finishes.
 */
- (void)createOrderCompletionBlock:(void(^)(NSError *))completionBlock;

/**
 * Saves shopping cart to the local storage.
 */
- (void)saveCart;
/**
 * Clears shopping cart properties.
 */
- (void)clearCart;

@end

NS_ASSUME_NONNULL_END
