//
//  ShoppingCart.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "ShoppingCart.h"
#import "User.h"
#import "BFAPIManager.h"
#import "BFError.h"
#import "BFCart.h"
#import "BFDataResponseCartInfo.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"

/**
 * NSCoding user defaults keys to identify saved properties.
 */
static NSString *const UserDefaultsShoppingCartKey                    = @"ShoppingCart";
static NSString *const UserDefaultsShoppingCartProductCountKey        = @"ShoppingCartProductCount";
static NSString *const UserDefaultsShoppingCartTotalPriceKey          = @"ShoppingCartTotalPrice";
static NSString *const UserDefaultsShoppingCartTotalPriceFormattedKey = @"ShoppingCartTotalPriceFormatted";
static NSString *const UserDefaultsShoppingCartCurrencyKey            = @"ShoppingCartCurrency";

/**
 * Property names used to match attributes during JSON serialization.
 */
static NSString *const ShoppingCartProductCountPropertyName           = @"productCount";
static NSString *const ShoppingCartTotalPricePropertyName             = @"totalPrice";
static NSString *const ShoppingCartTotalPriceFormattedPropertyName    = @"totalPriceFormatted";
static NSString *const ShoppingCartCurrencyPropertyName               = @"currency";

/**
 * Property JSON mappings used to match attributes during serialization.
 */
static NSString *const ShoppingCartProductCountPropertyJSONMapping        = @"product_count";
static NSString *const ShoppingCartTotalPricePropertyJSONMapping          = @"total_price";
static NSString *const ShoppingCartTotalPriceFormattedPropertyJSONMapping = @"total_price_formatted";
static NSString *const ShoppingCartCurrencyPropertyJSONMapping            = @"currency";


@interface ShoppingCart ()

@end


@implementation ShoppingCart

@synthesize paymentItems = _paymentItems;

#pragma mark - Initialization

+ (ShoppingCart *)sharedCart {
    static ShoppingCart *sharedCart = nil;
    @synchronized(self)
    {
        if (sharedCart == nil)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsShoppingCartKey];
            if (data != nil)
            {
                sharedCart = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (sharedCart == nil)
                {
                    sharedCart = [[self alloc] init];
                }
                
            } else {
                sharedCart = [[self alloc] init];
            }
        }
    }
    return sharedCart;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    // cart change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCart) name:BFCartDidChangeNotification object:nil];
    // cart synchronize listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeCart) name:BFCartWillSynchronizeNotification object:nil];
}

#pragma mark - Persistence Management

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self)
    {
        self.productCount = [aDecoder decodeObjectForKey:UserDefaultsShoppingCartProductCountKey];
        self.totalPrice = [aDecoder decodeObjectForKey:UserDefaultsShoppingCartTotalPriceKey];
        self.totalPriceFormatted = [aDecoder decodeObjectForKey:UserDefaultsShoppingCartTotalPriceFormattedKey];
        self.currency = [aDecoder decodeObjectForKey:UserDefaultsShoppingCartCurrencyKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.productCount forKey:UserDefaultsShoppingCartProductCountKey];
    [aCoder encodeObject:self.totalPrice forKey:UserDefaultsShoppingCartTotalPriceKey];
    [aCoder encodeObject:self.totalPriceFormatted forKey:UserDefaultsShoppingCartTotalPriceFormattedKey];
    [aCoder encodeObject:self.currency forKey:UserDefaultsShoppingCartCurrencyKey];
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             ShoppingCartProductCountPropertyName        : ShoppingCartProductCountPropertyJSONMapping,
             ShoppingCartTotalPricePropertyName          : ShoppingCartTotalPricePropertyJSONMapping,
             ShoppingCartTotalPriceFormattedPropertyName : ShoppingCartTotalPriceFormattedPropertyJSONMapping,
             ShoppingCartCurrencyPropertyName            : ShoppingCartCurrencyPropertyJSONMapping
             };
}

#pragma mark - User's order information

- (NSString *)name {
    if (!_name) {
        _name = [[User sharedUser] name];
    }
    return _name;
}

- (NSString *)email {
    if (!_email) {
        _email = [[User sharedUser] email];
    }
    return _email;
}

- (NSString *)phone {
    if (!_phone) {
        _phone = [[User sharedUser] phone];
    }
    return _phone;
}

- (NSString *)addressStreet {
    if (!_addressStreet) {
        _addressStreet = [[User sharedUser] addressStreet];
    }
    return _addressStreet;
}

- (NSString *)addressHouseNumber {
    if (!_addressHouseNumber) {
        _addressHouseNumber = [[User sharedUser] addressHouseNumber];
    }
    return _addressHouseNumber;
}

- (NSString *)addressCity {
    if (!_addressCity) {
        _addressCity = [[User sharedUser] addressCity];
    }
    return _addressCity;
}

- (NSString *)addressPostalCode {
    if (!_addressPostalCode) {
        _addressPostalCode = [[User sharedUser] addressPostalCode];
    }
    return _addressPostalCode;
}

#pragma mark - Shopping Cart Custom getters & setters

- (NSArray<BFCartPayment *>*)paymentItems {
    _paymentItems = [self.selectedDelivery.payments allObjects];
    return _paymentItems;
}

/**
 * Change shopping cart total price formatted according 
 * to the selected payment or shipping
 */
- (void)setSelectedDelivery:(BFCartDelivery *)selectedDelivery {
    _selectedDelivery = selectedDelivery;
    _selectedPayment = nil;
    if (selectedDelivery) {
        _totalPriceFormatted = selectedDelivery.totalPriceFormatted;
    }
}

- (void)setSelectedPayment:(BFCartPayment *)selectedPayment {
    if (selectedPayment) {
        _totalPriceFormatted = selectedPayment.totalPriceFormatted;
    }
    else if (_selectedDelivery) {
        _totalPriceFormatted = _selectedDelivery.totalPriceFormatted;
    }
    _selectedPayment = selectedPayment;
}

#pragma mark - Shopping Cart Badge refresh

- (void)refreshCart {
    [self findShoppingCartInfoCompletion:nil];
}

- (void)synchronizeCart {
    [self findShoppingCartContentsCompletion:nil];
}

#pragma mark - Shopping Cart Network requests

- (void)findShoppingCartContentsCompletion:(void(^)(NSError *))completion {
    // skip the request unless the user is logged
    // and set the value to 0
    if (![User isLoggedIn]) {
        self.productCount = nil;
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartBadgeValueDidChangeNotification];
    }
    else {
        [[BFAPIManager sharedManager] findShoppingCartContentsWithCompletionBlock:^(NSArray * _Nullable records, id  _Nullable customResponse, NSError * _Nullable error) {
            // error results
            if(error) {
                if (completion) {
                    completion(error);
                }
            }
            else {
                BFCart *cart = [records firstObject];
                NSError *updateError;
                // update model with the JSON response
                if ([self updateWithJSONDictionary:customResponse error:&updateError]) {
                    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartBadgeValueDidChangeNotification];
                    
                    self.products = [[NSMutableArray alloc] initWithArray:[cart.products array]];
                    self.discounts = [[NSMutableArray alloc] initWithArray:[cart.discounts array]];
                    
                    if (completion) {
                        completion(nil);
                    }
                }
                else {
                    if (completion) {
                        completion(updateError);
                    }
                }
            }
        }];
    }
}

- (void)findShoppingCartInfoCompletion:(void(^)(NSError *))completion {
    // skip the request unless the user is logged
    // and set the value to 0
    if (![User isLoggedIn]) {
        self.productCount = nil;
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartBadgeValueDidChangeNotification];
    }
    else {
        [[BFAPIManager sharedManager] findShoppingCartInfoWithCompletionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            if(!error && response) {
                NSError *updateError;
                // update model with the JSON response
                if ([self updateWithJSONDictionary:response error:&updateError]) {
                    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartBadgeValueDidChangeNotification];
                    if (completion) {
                        completion(nil);
                    }
                }
                else {
                    if (completion) {
                        completion(updateError);
                    }
                }
            }
            else {
                if (completion) {
                    completion(error);
                }
            }
        }];
    }
}

#pragma mark - Shopping Cart Products and discounts removal

- (void)removeCartProductItem:(BFCartProductItem *)cartProductItem didStartCallback:(void(^)())didStartCallback didFinishCallback:(void(^)(NSError *))didFinishCallback {
    // removing temporary objects
    cartProductItem.cart = nil;
    [self.products removeObject:cartProductItem];
    
    BFAPIRequestCartProductInfo *cartProductInfo = [[BFAPIRequestCartProductInfo alloc] initWithCartProductIdentification:cartProductItem.cartItemID quantity:cartProductItem.quantity];
    [[BFAPIManager sharedManager] deleteProductVariantInCartWithInfo:cartProductInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if(!error) {
            // remove the product item from current context
            [[StorageManager defaultManager]deleteProductCartItem:cartProductItem completionBlock:^(NSError * _Nonnull error) {
                if (didFinishCallback) {
                    didFinishCallback(error);
                }
            }];
        }
        else {
            if (didFinishCallback) {
                didFinishCallback(error);
            }
        }
    }];
    
    if (didStartCallback) {
        didStartCallback();
    }

}

- (void)removeCartDiscountItem:(BFCartDiscountItem *)cartDiscountItem didStartCallback:(void(^)())didStartCallback didFinishCallback:(void(^)(NSError *))didFinishCallback {
    // removing temporary objects
    cartDiscountItem.cart = nil;
    [self.discounts removeObject:cartDiscountItem];

    BFAPIRequestCartDiscountInfo *cartDiscountInfo = [[BFAPIRequestCartDiscountInfo alloc] initWithDiscountIdentifier:cartDiscountItem.discountID];
    [[BFAPIManager sharedManager] deleteDiscountInCartWithInfo:cartDiscountInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if(!error) {
            // remove the product item from current context
            [[StorageManager defaultManager]deleteDiscountInCart:cartDiscountItem completionBlock:^(NSError * _Nonnull error) {
                if (didFinishCallback) {
                    didFinishCallback(error);
                }
            }];
        }
        else {
            if (didFinishCallback) {
                didFinishCallback(error);
            }
        }
    }];
    
    if (didStartCallback) {
        didStartCallback();
    }
}

#pragma mark - Order network request

- (void)createOrderCompletionBlock:(void(^)(NSError *))completionBlock {
    BFAPIRequestOrderInfo *orderInfo = [[BFAPIRequestOrderInfo alloc] init];
    
    orderInfo.name = self.name;
    orderInfo.email = self.email;
    orderInfo.phone = self.phone;
    orderInfo.addressStreet = self.addressStreet;
    orderInfo.addressHouseNumber = self.addressHouseNumber;
    orderInfo.addressCity = self.addressCity;
    orderInfo.addressPostalCode = self.addressPostalCode;
    orderInfo.note = self.note;
    orderInfo.shippingID = self.selectedDelivery.deliveryID;
    orderInfo.paymentID = self.selectedPayment.paymentID;
    
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager] createOrderWithInfo:orderInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        // update user info from the response
        NSError *updateError;
        // parse and save received response data
        if([[User sharedUser]updateWithJSONDictionary:response error:&updateError]) {
            [[User sharedUser]saveUser];
        }

        // order completion block
        __typeof__(weakSelf) strongSelf = weakSelf;
        if (error) {
            if (completionBlock) {
                completionBlock(error);
            }
        }
        else {
            [strongSelf refreshCart];
            
            if (completionBlock) {
                completionBlock(nil);
            }
        }
    }];

}

#pragma mark - Custom Mantle Model Merging

// overriding merge method prevents from deleting properties
// from partial JSON
- (void)mergeValuesForKeysFromModel:(id<MTLModel>)model {
    NSSet *propertyKeys = model.class.propertyKeys;
    NSArray *mantlePropertyKeys = [[[model class] JSONKeyPathsByPropertyKey] allKeys];
    
    for (NSString *key in self.class.propertyKeys) {
        if (![propertyKeys containsObject:key]) continue;
        if (![mantlePropertyKeys containsObject:key]) continue;
        
        [self mergeValueForKey:key fromModel:model];
    }
}

#pragma mark - Shopping Cart Validation

- (BFAddressItem)incompleteAddressItem
{
    BFAddressItem incompleteItem = BFAddressItemUnkown;
    
    if (!self.name || !self.name.length) {
        incompleteItem = BFAddressItemName;
    } else if (!self.email || !self.email.length) {
        incompleteItem = BFAddressItemEmail;
    } else if (!self.addressStreet || !self.addressStreet.length) {
        incompleteItem = BFAddressItemStreet;
    } else if (!self.addressHouseNumber || !self.addressHouseNumber.length) {
        incompleteItem = BFAddressItemHouseNumber;
    } else if (!self.addressCity || !self.addressCity.length) {
        incompleteItem = BFAddressItemCity;
    } else if (!self.addressPostalCode || !self.addressPostalCode.length) {
        incompleteItem = BFAddressItemPostalCode;
    } else if (!self.phone || !self.phone.length) {
        incompleteItem = BFAddressItemPhoneNumber;
    }
    
    return incompleteItem;
}

- (BFShippingAndPaymentItem)incompleteShippingPaymentItem
{
    BFShippingAndPaymentItem incompleteItem = BFShippingAndPaymentItemUnkown;
    
    if (!self.selectedDelivery) {
        incompleteItem = BFShippingAndPaymentItemShipping;
    } else if (!self.selectedPayment) {
        incompleteItem = BFShippingAndPaymentItemPayment;
    }
    
    return incompleteItem;
}

- (BOOL)isValid
{
    BOOL isValid = YES;
    if ([self incompleteAddressItem] || [self incompleteShippingPaymentItem]) {
        isValid = NO;
    }
    return isValid;
}

- (BOOL)isValidWithIncompleteShippingPaymentHandler:(void(^)(BFShippingAndPaymentItem))incompleteShippingPaymentHandler incompleteAddressHandler:(void(^)(BFAddressItem))incompleteAddressHandler {
    BOOL isValid = YES;
    BFAddressItem incompleteAddressItem = [self incompleteAddressItem];
    BFShippingAndPaymentItem incompleteShippingPaymentItem = [self incompleteShippingPaymentItem];
    
    if (incompleteShippingPaymentItem) {
        isValid = NO;
        if (incompleteShippingPaymentHandler) {
            incompleteShippingPaymentHandler(incompleteShippingPaymentItem);
        }
    }
    else if (incompleteAddressItem) {
        isValid = NO;
        if (incompleteAddressHandler) {
            incompleteAddressHandler(incompleteAddressItem);
        }
    }
    return isValid;
    
}

#pragma mark - Shopping Cart State Management

- (void)saveCart {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:UserDefaultsShoppingCartKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearCart {
    // clean properties
    self.totalPriceFormatted = nil;
    self.totalPrice = nil;
    self.productCount = nil;
    self.currency = nil;
    
    // clean user info
    self.name = nil;
    self.email = nil;
    self.addressStreet = nil;
    self.addressHouseNumber = nil;
    self.addressCity = nil;
    self.addressPostalCode = nil;
    self.phone = nil;
    self.note = nil;
    
    // clean order info
    self.deliveryItems = nil;
    self.selectedDelivery = nil;
    self.paymentItems = nil;
    self.selectedPayment = nil;
    self.products = nil;
    self.discounts = nil;
    
    // clean user defaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefaultsShoppingCartKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
