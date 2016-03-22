//
//  BFKeystore.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFKeystore.h"
#import "SSKeychain.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"

/**
 * Keystore component (service) name.
 */
static NSString *const appServiceName = @"OpenShop";
/**
 * Identification key for access token in the keystore.
 */
static NSString *const accessTokenKey = @"AccessToken";


@implementation BFKeystore


#pragma mark - Access Token

+ (BOOL)isLoggedIn {
    return [BFKeystore accessToken] != nil;
}

+ (NSString *)accessToken {
    return [BFKeystore secureValueForKey:accessTokenKey];
}

+ (BOOL)setAccessToken:(NSString *)accessToken {
    BOOL result = [BFKeystore setSecureValue:accessToken forKey:accessTokenKey];
    // notify access token change
    if(result) {
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFKeyStoreDidChangeAccessTokenChangedNotification];
    }
    return result;
}

+ (BOOL)setAccessToken:(NSString *)accessToken error:(NSError *__autoreleasing *)error {
    BOOL result = [BFKeystore setSecureValue:accessToken forKey:accessTokenKey error:error];
    // notify access token change
    if(result) {
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFKeyStoreDidChangeAccessTokenChangedNotification];
    }
    return result;
}


#pragma mark - Keystore Management

+ (void)clearSavedCredentials {
    [self setAccessToken:nil];
}

+ (BOOL)setSecureValue:(NSString *)value forKey:(NSString *)key {
    return [self setSecureValue:value forKey:key error:nil];
}

+ (BOOL)setSecureValue:(NSString *)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    // allow accessibility
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SSKeychain setAccessibilityType:kSecAttrAccessibleAlways];
    });
    // nil value removes the key
    if (value) {
        return [SSKeychain setPassword:value forService:appServiceName account:key error:error];
    }
    else {
        return [SSKeychain deletePasswordForService:appServiceName account:key error:error];
    }
}

+ (NSString *)secureValueForKey:(NSString *)key {
    return [self secureValueForKey:key error:nil];
}

+ (NSString *)secureValueForKey:(NSString *)key error:(NSError *__autoreleasing *)error{
    return [SSKeychain passwordForService:appServiceName account:key error:error];
}

@end
