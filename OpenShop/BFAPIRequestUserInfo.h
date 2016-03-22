//
//  BFAPIRequestUserInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAPIRequestUserInfo` encapsulates user information used in remote API communication. It contains information
 * required for user login, registration, information retrieval, password changes and the verification process.
 */
@interface BFAPIRequestUserInfo : BFJSONSerializableObject
/**
 * User e-mail address.
 */
@property (copy, nullable) NSString *email;
/**
 * User password.
 */
@property (copy, nullable) NSString *password;
/**
 * User old password intended to be changed from.
 */
@property (copy, nullable) NSString *passwordOld;
/**
 * User new password intended to be changed to.
 */
@property (copy, nullable) NSString *passwordNew;
/**
 * User gender.
 */
@property (copy, nullable) NSString *gender;
/**
 * User unique facebook identification number.
 */
@property (strong, nullable) NSNumber *facebookID;
/**
 * User unique facebook access token.
 */
@property (copy, nullable) NSString *facebookAccessToken;


/**
 * Initializes an `BFAPIRequestUserInfo` object with user email and password.
 *
 * @param email User e-mail address.
 * @param password User password.
 * @return The newly-initialized `BFAPIRequestUserInfo`.
 */
- (instancetype)initWithEmail:(nullable NSString *)email
                     password:(nullable NSString *)password;

/**
 * Initializes an `BFAPIRequestUserInfo` object with current user password which is inteded to be changed to
 * the specified new password.
 *
 * @param passwordOld Current user password.
 * @param passwordNew New user password.
 * @return The newly-initialized `BFAPIRequestUserInfo`.
 */
- (instancetype)initWithOldPassword:(nullable NSString *)passwordOld
                        newPassword:(nullable NSString *)passwordNew;

@end

NS_ASSUME_NONNULL_END
