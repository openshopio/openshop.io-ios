//
//  BFAPIManager.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAPIManager.h"
#import "BFAPIPath.h"
#import "BFKeyStore.h"
#import "BFAppSessionInfo.h"
#import "BFAppPreferences.h"
#import "BFPushNotificationHandler.h"
#import "BFJSONResponseSerializer.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "AFMMRecordSessionManagerServer.h"
#import "PersistentStorage.h"
#import "User.h"
#import "BFRecord.h"
#import "BFShop.h"
#import "BFBranch.h"
#import "BFInfoPage.h"
#import "BFCategory.h"
#import "BFBanner.h"
#import "BFProduct.h"
#import "BFProductVariant.h"
#import "BFCartProductItem.h"
#import "BFCartDelivery.h"
#import "BFDeliveryInfo.h"
#import "BFOrder.h"
#import "BFOrderShipping.h"
#import "BFWishlistItem.h"
#import "BFRegion.h"
#import "BFCart.h"
#import "BFCartDiscountItem.h"
#import "BFTranslation.h"
#import "BFCategoriesParsingOperation.h"
#import "BFProductFiltersParsingOperation.h"
#import "BFWishlistProductsParsingOperation.h"
#import "BFTranslationsParsingOperation.h"
#import "BFOrderDetailsParsingOperation.h"
#import "BFOrderItem.h"

/**
 * API service request header key to identify client.
 */
static NSString *const APIRequestHeaderClientVersion    = @"Client-Version";
/**
 * API service request header key to identify device.
 */
static NSString *const APIRequestHeaderDeviceToken      = @"Device-Token";
/**
 * API service response header key to identify caching.
 */
static NSString *const APIResponseHeaderCacheControl    = @"Cache-Control";
/**
 * API service response header key to identify the response expiration.
 */
static NSString *const APIResponseHeaderExpires         = @"Expires";
/**
 * API service JSON response access token key.
 */
static NSString *const APIResponseAccessTokenJSONKey    = @"access_token";

/**
 * API service response default HTTP version.
 */
static NSString *const APIResponseDefaultHTTPVersion    = @"HTTP/1.1";
/**
 * API service response default cache control header.
 */
static NSString *const APIResponseDefaultCacheControl   = @"s-maxage=180, max-age=180";


@interface BFAPIManager ()

/**
 * API service responses parsing operation queue.
 */
@property (nonatomic, strong) NSOperationQueue *parsingQueue;
/**
 * User authorization header is conditionally disabled if set.
 */
@property (nonatomic, assign) BOOL authCondDisabled;

@end


@implementation BFAPIManager


#pragma mark - Initialization

+ (instancetype)sharedManager {
    static BFAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    // execute initialization exactly once
    dispatch_once(&onceToken, ^{
        sharedManager = [[BFAPIManager alloc] initWithBaseURL:[NSURL URLWithString:[BFAPIPath APIBaseURL]]];
        // API response parsing queue
        sharedManager.parsingQueue = [[NSOperationQueue alloc]init];
    });
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        // JSON request serializer params
        AFJSONRequestSerializer* requestSerializer = [[AFJSONRequestSerializer alloc] init];
        requestSerializer.writingOptions = NSJSONWritingPrettyPrinted;
        [requestSerializer setValue:[BFAppSessionInfo versionBuild] forHTTPHeaderField:APIRequestHeaderClientVersion];
        [requestSerializer setValue:[BFAppSessionInfo deviceToken] forHTTPHeaderField:APIRequestHeaderDeviceToken];
        
        self.requestSerializer = requestSerializer;
        // access token
        if ([BFKeystore isLoggedIn]) {
            [self setAccessToken];
        }
        
        // compound response serializer of custom JSON response serializer and default HTTP response serializer
        self.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[BFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer]]];
        // register for access token changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(accessTokenChanged:)
                                                     name:BFKeyStoreDidChangeAccessTokenChangedNotification
                                                   object:nil];
        
        // response caching clarification
        [self setDataTaskWillCacheResponseBlock:^NSCachedURLResponse * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSCachedURLResponse * _Nonnull proposedResponse) {
            
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)proposedResponse.response;
            NSDictionary *HTTPHeaders = HTTPResponse.allHeaderFields;
            // caching enabled
            if(dataTask.originalRequest.cachePolicy == NSURLRequestUseProtocolCachePolicy) {
                NSString *cacheControl = [HTTPHeaders valueForKey:APIResponseHeaderCacheControl];
                NSString *expires = [HTTPHeaders valueForKey:APIResponseHeaderExpires];
                // no cache control or expiration
                if(!cacheControl && !expires) {
                    // manually set cache control
                    NSMutableDictionary *modifiedHeaders = HTTPHeaders.mutableCopy;
                    [modifiedHeaders setObject:APIResponseDefaultCacheControl forKey:APIResponseHeaderCacheControl];
                    // modified HTTP response
                    NSHTTPURLResponse *modifiedHTTPResponse = [[NSHTTPURLResponse alloc]initWithURL:(NSURL *)HTTPResponse.URL statusCode:HTTPResponse.statusCode HTTPVersion:APIResponseDefaultHTTPVersion headerFields:modifiedHeaders];
                    // modified cached response
                    proposedResponse = [[NSCachedURLResponse alloc] initWithResponse:modifiedHTTPResponse data:proposedResponse.data userInfo:proposedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
                }
            }
            
            return proposedResponse;
        }];

        // register managed object models
        [AFMMRecordSessionManagerServer registerAFHTTPSessionManager:self];
        [BFRecord registerServerClass:[AFMMRecordSessionManagerServer class]];
    }
    return self;
}


#pragma mark - Data Task

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))originalCompletionHandler {
    // enable authorization if its conditionally disabled
    if(self.authCondDisabled) {
        [self enableAuthorization];
    }
    return [super dataTaskWithRequest:request completionHandler:originalCompletionHandler];
}


#pragma mark - Authorization

- (void)disableAuthorization {
    [self setAccessToken:nil];
}

- (void)disableAuthorizationForSingleRequest {
    [self setAccessToken:nil];
    // authorization is conditionally disabled
    self.authCondDisabled = true;
}

- (void)enableAuthorization {
    [self setAccessToken:[BFKeystore accessToken]];
    self.authCondDisabled = false;
}

- (void)accessTokenChanged:(NSNotification *)notification {
    [self setAccessToken];
}

- (void)setAccessToken {
    [self setAccessToken:[BFKeystore accessToken]];
}

- (void)setAccessToken:(NSString *)accessToken {
    if(accessToken) {
        // authorization is not conditionally disabled
        self.authCondDisabled = false;
        // HTTP Auth Basic username:password
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:accessToken password:@""];
    }
    else {
        [self.requestSerializer clearAuthorizationHeader];
    }
}


#pragma mark - API Info Requests

- (void)POSTInfoRequestWithURLString:(NSString *)URLString parameters:(BFJSONSerializableObject *)parameters completionBlock:(BFAPIInfoCompletionBlock) block {
    NSError *error;
    NSDictionary *dictParameters = [parameters JSONDictionaryWithError:&error];

    if(error) {
        if(block) {
            block(nil, error);
        }
    }
    else {
        [self POST:URLString parameters:dictParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (block) {
                block(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil, error);
            }
        }];
    }
}

- (void)GETInfoRequestWithURLString:(NSString *)URLString parameters:(BFJSONSerializableObject *)parameters completionBlock:(BFAPIInfoCompletionBlock) block {
    NSError *error;
    NSDictionary *dictParameters = [parameters JSONDictionaryWithError:&error];
    
    if(error) {
        if(block) {
            block(nil, error);
        }
    }
    else {
        [self GET:URLString parameters:dictParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (block) {
                    block(responseObject, nil);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil, error);
            }
        }];
    }
}

- (void)PUTInfoRequestWithURLString:(NSString *)URLString parameters:(BFJSONSerializableObject *)parameters completionBlock:(BFAPIInfoCompletionBlock) block {
    NSError *error;
    NSDictionary *dictParameters = [parameters JSONDictionaryWithError:&error];

    if(error) {
        if(block) {
            block(nil, error);
        }
    }
    else {
        [self PUT:URLString parameters:dictParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (block) {
                    block(responseObject, nil);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil, error);
            }
        }];
    }
}

- (void)DELETEInfoRequestWithURLString:(NSString *)URLString parameters:(BFJSONSerializableObject *)parameters completionBlock:(BFAPIInfoCompletionBlock) block {
    NSError *error;
    NSDictionary *dictParameters = [parameters JSONDictionaryWithError:&error];

    if(error) {
        if(block) {
            block(nil, error);
        }
    }
    else {
        [self DELETE:URLString parameters:dictParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (block) {
                    block(responseObject, nil);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil, error);
            }
        }];
    }
}


#pragma mark - API Data Loading Requests

- (void)dataLoadingRequestWithParameters:(BFJSONSerializableObject *)parameters completionBlock:(BFAPIDataLoadingCompletionBlock)block executionBlock:(void(^)(NSDictionary *parameters))execution {
    NSError *error;
    NSDictionary *dictParameters = [parameters JSONDictionaryWithError:&error];
    
    if(error) {
        if(block) {
            block(nil, nil, error);
        }
    }
    else if(execution) {
        execution(dictParameters.count ? dictParameters : nil);
    }
}


#pragma mark - User Login & Registration

- (void)registerUserWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock)block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserRegister];

    [self POSTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
}

- (void)loginUserWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock)block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserLogin];
    
    [self POSTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
}

- (void)verifyUserWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock)block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserVerify];
    
    [self POSTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
}

- (void)verifyUserWithFacebookInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock)block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserFacebookVerify];
    
    [self POSTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
}

- (BFError *)finishUserRequestWithResponse:(NSDictionary *)response {
    BFError *error;
    id token = [response objectForKey:APIResponseAccessTokenJSONKey];
    // token validation
    if (token && [token isKindOfClass:[NSString class]]) {
        NSError *updateError;
        // parse and save received response data
        if([[User sharedUser]updateWithJSONDictionary:response error:&updateError]) {
            if([BFKeystore setAccessToken:token error:&updateError]) {
                [self setAccessToken:token];
                [[User sharedUser]saveUser];
                [BFPushNotificationHandler registerDeviceWithApnsID:[[BFAppPreferences sharedPreferences] APNIdentification]];
                // update shopping cart badge value
                [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartWillSynchronizeNotification];
            }
            else {
                error = [BFError errorWithError:updateError];
            }
        }
        else {
            error = [BFError errorWithError:updateError];
        }
    } else {
        error = [BFError errorWithCode:BFErrorCodeUserLogin];
    }
    return error;
}


#pragma mark - User Details

- (void)findUserDetailsWithCompletionBlock:(BFAPIInfoCompletionBlock) block {
    NSNumber *identification = [[User sharedUser]identification];
    // user must be logged in to retrieve his information
    if([User isLoggedIn] && identification) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserDetails params:@[identification]];
        [self GETInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
    }
}

- (void)updateUserDetailsWithCompletionBlock:(BFAPIInfoCompletionBlock) block {
    NSNumber *identification = [[User sharedUser]identification];
    // user must be logged in to update his information
    if([User isLoggedIn] && identification) {
        [self updateUserDetailsWithAccessToken:nil userIdentication:identification completionBlock:block];
    }
}

- (void)updateUserDetailsWithAccessToken:(NSString *)accessToken userIdentication:(NSNumber *)identification completionBlock:(BFAPIInfoCompletionBlock) block {
    if(identification) {
        if(accessToken) {
            [self setAccessToken:accessToken];
        }
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserDetails params:@[identification]];
        
        [self PUTInfoRequestWithURLString:requestURL parameters:[User sharedUser] completionBlock:block];
    }
}

- (void)changeUserPasswordWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock) block {
    NSNumber *identification = [[User sharedUser]identification];
    // user must be logged in to change his password
    if([User isLoggedIn] && identification) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserPasswordChange(identification)];
    
        [self PUTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
    }
}

- (void)resetUserPasswordWithInfo:(BFAPIRequestUserInfo *)info completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathUserPasswordReset];
    
    [self POSTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
}


#pragma mark - Device & Application Info

- (void)registerDeviceWithInfo:(BFAPIRequestDeviceInfo *)info completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathDeviceRegistration];
    
    [self POSTInfoRequestWithURLString:requestURL parameters:info completionBlock:block];
}

- (void)findTermsAndConditionsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathTermsAndConditions];
    
    [BFInfoPage startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findInfoPagesWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathInfoPages];
    
    // setup collection options
    [BFInfoPage setOptions:[BFRecord defaultOptions]];
    [BFInfoPage startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findInfoPageWithIdentification:(NSNumber *)identification completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathInfoPages params:@[identification]];
    
    [BFInfoPage startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}


#pragma mark - Shops

- (void)findShopsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestOrganizationURLWithPath:BFAPIRequestPathShops];
    
    // conditionally disable authorization
    [self disableAuthorizationForSingleRequest];
    [BFShop setOptions:[BFRecord defaultOptions]];
    [BFShop startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findShopWithIdentification:(NSNumber *)identification completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestOrganizationURLWithPath:BFAPIRequestPathShops params:@[identification]];
    
    [BFShop startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}


#pragma mark - Categories, Banners

- (void)findCategoriesWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathCategories];
    
    [BFCategory setOptions:[BFCategory defaultOptions]];
    [BFCategory startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        // raw data to parse categories
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        if(block) {
            // manual categories parsing
            BFCategoriesParsingOperation *operation = [[BFCategoriesParsingOperation alloc]initWithRawData:customResponseObject completionBlock:block];
            [self.parsingQueue addOperation:operation];
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findCategoriesWithMenuCategory:(BFMenuCategory)menuCategory completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL;
    // if the menu category is none then don't append it to the request path
    if (menuCategory == BFMenuCategoryNone) {
        requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathCategories];
    }
    else {
        requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathCategories params:@[[BFAppStructure menuCategoryAPIName:menuCategory]]];
    }
    
    [BFCategory setOptions:[BFCategory defaultOptions]];
    [BFCategory startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        // raw data to parse categories
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        // manual categories parsing
        BFCategoriesParsingOperation *operation = [[BFCategoriesParsingOperation alloc]initWithRawData:customResponseObject completionBlock:block];
        [self.parsingQueue addOperation:operation];
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
    
}

- (void)findBannersWithInfo:(BFDataRequestPagerInfo *)info completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    [self dataLoadingRequestWithParameters:info completionBlock:block executionBlock:^(NSDictionary *parameters) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathBanners];
        
        [BFBanner startRequestWithURN:requestURL data:parameters context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
            // filters parsing
            return nil;
        } resultBlock:^(NSArray *records, id customResponseObject) {
            if(block) {
                block(records, customResponseObject, nil);
            }
        } failureBlock:^(NSError *error) {
            if(block) {
                block(nil, nil, error);
            }
        }];
    }];
}


#pragma mark - Shop Branches, Regions

- (void)findBranchesWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShopBranches];
    
    [BFBranch startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findRegionsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShopRegions];
    
    [BFRegion startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}


#pragma mark - Products & Variants

- (void)findProductsWithInfo:(BFDataRequestProductInfo *)productInfo completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    [self dataLoadingRequestWithParameters:productInfo completionBlock:block executionBlock:^(NSDictionary *parameters) {
        NSString *requestURL;
        if (productInfo.menuCategory && productInfo.staticMenuCategory) {
            requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathProducts params:@[[BFAppStructure menuCategoryDisplayName:[productInfo.menuCategory integerValue]], [BFAppStructure staticMenuCategoryAPIName:[productInfo.staticMenuCategory integerValue]]]];
        }
        else {
            requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathProducts];
        }
        
        // setup collection options
        [BFProduct setOptions:[BFProduct collectionOptions]];
        [BFProduct startRequestWithURN:requestURL data:parameters context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
            return JSON;
        } resultBlock:^(NSArray *records, id customResponseObject) {
            // product filters parsing
            BFProductFiltersParsingOperation *operation = [[BFProductFiltersParsingOperation alloc]initWithRawData:customResponseObject completionBlock:block records:records];
            [self.parsingQueue addOperation:operation];
        } failureBlock:^(NSError *error) {
            if(block) {
                block(nil, nil, error);
            }
        }];
    }];
}

- (void)findProductDetailsWithInfo:(BFDataRequestProductInfo *)productInfo completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    [self dataLoadingRequestWithParameters:productInfo completionBlock:block executionBlock:^(NSDictionary *parameters) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathProducts params:@[productInfo.productID]];
        
        [BFProduct startRequestWithURN:requestURL data:parameters context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
            if(block) {
                block(records, nil, nil);
            }
        } failureBlock:^(NSError *error) {
            if(block) {
                block(nil, nil, error);
            }
        }];
    }];
}

- (void)findProductVariantDetailsWithInfo:(BFDataRequestProductInfo *)productInfo completionBlock:(BFAPIDataLoadingCompletionBlock) block {
    [self dataLoadingRequestWithParameters:productInfo completionBlock:block executionBlock:^(NSDictionary *parameters) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathProductVariants(productInfo.productID) params:@[productInfo.productVariantID]];
        
        [BFProductVariant startRequestWithURN:requestURL data:parameters context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
            if(block) {
                block(records, nil, nil);
            }
        } failureBlock:^(NSError *error) {
            if(block) {
                block(nil, nil, error);
            }
        }];
    }];
}


#pragma mark - Shopping Cart Contents & Info

- (void)findShoppingCartContentsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCart];
    
    [BFCart startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        if(block) {
            block(records, customResponseObject, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findShoppingCartInfoWithCompletionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCartInfo];

    [self GETInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}


#pragma mark - Shopping Cart Modification

- (void)addProductVariantToCartWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCart];

    [self POSTInfoRequestWithURLString:requestURL parameters:cartInfo completionBlock:block];
}

- (void)updateProductVariantInCartWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCart params:@[cartInfo.cartProductID]];

    [self PUTInfoRequestWithURLString:requestURL parameters:cartInfo completionBlock:block];
}

- (void)deleteProductVariantInCartWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCart params:@[cartInfo.cartProductID]];
    
    [self DELETEInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}


#pragma mark - Shopping Cart Discounts

- (void)addDiscountToCartWithInfo:(BFAPIRequestCartDiscountInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCartDiscounts];

    [self POSTInfoRequestWithURLString:requestURL parameters:cartInfo completionBlock:block];
}

- (void)deleteDiscountInCartWithInfo:(BFAPIRequestCartDiscountInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCartDiscounts params:@[cartInfo.discountID]];

    [self DELETEInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}


#pragma mark - Shopping Cart Delivery Info

- (void)findShoppingCartDeliveryInfoWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShoppingCartDeliveryInfo];
    [BFDeliveryInfo startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        if(block) {
            block(records, customResponseObject, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}


#pragma mark - Shopping Cart Reservations

- (void)findReservedProductVariantsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathReservations];
    
    [BFCartProductItem startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        // product inside product variant parsing
        if(block) {
            block(records, customResponseObject, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)deleteReservedProductVariantWithInfo:(BFAPIRequestCartProductInfo *)cartInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathReservations params:@[cartInfo.cartProductID]];
    
    [self DELETEInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}


#pragma mark - Orders & Shipping

- (void)findShippingWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathShipping];
    
    [BFOrderShipping startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
        if(block) {
            block(records, nil, nil);
        }
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)findOrdersWithInfo:(BFDataRequestPagerInfo *)info completionBlock:(BFAPIDataLoadingCompletionBlock) block {

    [self dataLoadingRequestWithParameters:info completionBlock:block executionBlock:^(NSDictionary *parameters) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathOrders];
        
        [BFOrder setOptions:[BFRecord defaultOptions]];
        [BFOrder startRequestWithURN:requestURL data:parameters context:[[StorageManager defaultManager] privateQueueContext] domain:self resultBlock:^(NSArray *records) {
            if(block) {
                block(records, nil, nil);
            }
        } failureBlock:^(NSError *error) {
            if(block) {
                block(nil, nil, error);
            }
        }];
    }];
}

- (void)findOrderDetailsWithInfo:(BFAPIRequestOrderInfo *)orderInfo completionBlock:(BFAPIDataLoadingCompletionBlock) block {

    [self dataLoadingRequestWithParameters:nil completionBlock:block executionBlock:^(NSDictionary *parameters) {
        NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathOrders params:@[orderInfo.orderID]];
        
        [BFOrder startRequestWithURN:requestURL data:parameters context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
            return JSON;
        } resultBlock:^(NSArray *records, id customResponseObject) {
            // order detail parsing
            BFOrderDetailsParsingOperation *operation = [[BFOrderDetailsParsingOperation alloc]initWithRawData:customResponseObject completionBlock:block records:records];
            [self.parsingQueue addOperation:operation];
        } failureBlock:^(NSError *error) {
            if(block) {
                block(nil, nil, error);
            }
        }];
    }];
}

- (void)createOrderWithInfo:(BFAPIRequestOrderInfo *)orderInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathOrders];

    [self POSTInfoRequestWithURLString:requestURL parameters:orderInfo completionBlock:block];
}


#pragma mark - Wishlist

- (void)findWishlistContentsWithCompletionBlock:(BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathWishlist];
 
    [BFWishlistItem startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        // products parsing inside product variants
        BFWishlistProductsParsingOperation *operation = [[BFWishlistProductsParsingOperation alloc]initWithRawData:customResponseObject completionBlock:block records:records];
        [self.parsingQueue addOperation:operation];
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}

- (void)addProductVariantToWishlistWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathWishlist];

    [self POSTInfoRequestWithURLString:requestURL parameters:wishlistInfo completionBlock:block];
}

- (void)deleteProductVariantInWishlistWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL;
    if (wishlistInfo.wishlistID) {
        requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathWishlist params:@[wishlistInfo.wishlistID]];
    }
    else {
        requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathWishlistProduct params:@[wishlistInfo.productVariantID]];
    }
    
    [self DELETEInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}

- (void)moveProductVariantInWishlistToCartWithInfo:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathWishlistToCart(wishlistInfo.wishlistID)];

    [self PUTInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}

- (void)isProductVariantInWishlist:(BFDataRequestWishlistInfo *)wishlistInfo completionBlock:(BFAPIInfoCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIRequestShopURLWithPath:BFAPIRequestPathWishlistIsProductIn params:@[wishlistInfo.productVariantID]];

    [self GETInfoRequestWithURLString:requestURL parameters:nil completionBlock:block];
}


#pragma mark - Translations

- (void)findTranslationWithLanguageCode:(NSString *)languageCode completionBlock:(nullable BFAPIDataLoadingCompletionBlock) block {
    NSString *requestURL = [BFAPIPath APIBaseURLWithPath:BFAPIRequestPathTranslations params:@[languageCode] relative:true];
    
    // conditionally disable authorization
    [self disableAuthorizationForSingleRequest];
    [BFTranslation startRequestWithURN:requestURL data:nil context:[[StorageManager defaultManager] privateQueueContext] domain:self customResponseBlock:^id(id JSON) {
        return JSON;
    } resultBlock:^(NSArray *records, id customResponseObject) {
        // translations parsing
        BFTranslationsParsingOperation *operation = [[BFTranslationsParsingOperation alloc]initWithRawData:customResponseObject completionBlock:block];
        [self.parsingQueue addOperation:operation];
    } failureBlock:^(NSError *error) {
        if(block) {
            block(nil, nil, error);
        }
    }];
}


@end
