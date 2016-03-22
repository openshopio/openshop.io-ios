//
//  BFKeystore.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 * Key store handles the secure storage of credentials in the system keychain.
 */
@interface BFKeystore : NSObject

/**
 * Checks whether the key store has a saved access token.
 *
 * @return TRUE if the keystore has a token, else FALSE.
 */
+ (BOOL)isLoggedIn;

/**
 * Clears the saved credentials.
 */
+ (void)clearSavedCredentials;

/**
 * Retrieves the access token.
 *
 * @return The raw access token.
 */
+ (nullable NSString *)accessToken;

/**
 * Stores the access token.
 *
 * @param accessToken The access token. Nil value removes the token.
 * @return The operation result state.
 */
+ (BOOL)setAccessToken:(nullable NSString *)accessToken;
/**
 * Stores the access token with optional error response.
 *
 * @param accessToken The access token. Nil value removes the token.
 * @param error The error that might occur during the operation.
 * @return The operation result state.
 */
+ (BOOL)setAccessToken:(NSString *)accessToken error:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
