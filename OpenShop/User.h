//
//  User.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Property names used to match attributes during JSON serialization.
 */
static NSString *const UserIdentificationPropertyName                = @"identification";
static NSString *const UserRemoteIdentificationPropertyName          = @"remoteIdentification";
static NSString *const UserFacebookIdentificationPropertyName        = @"facebookIdentification";
static NSString *const UserNamePropertyName                          = @"name";
static NSString *const UserEmailPropertyName                         = @"email";
static NSString *const UserGenderPropertyName                        = @"gender";
static NSString *const UserPhonePropertyName                         = @"phone";
static NSString *const UserAddressStreetPropertyName                 = @"addressStreet";
static NSString *const UserAddressHouseNumberPropertyName            = @"addressHouseNumber";
static NSString *const UserAddressCityPropertyName                   = @"addressCity";
static NSString *const UserAddressPostalCodePropertyName             = @"addressPostalCode";

/**
 * Property JSON mappings used to match attributes during serialization.
 */
static NSString *const UserIdentificationPropertyJSONMapping         = @"id";
static NSString *const UserRemoteIdentificationPropertyJSONMapping   = @"remote_id";
static NSString *const UserFacebookIdentificationPropertyJSONMapping = @"fb_id";
static NSString *const UserNamePropertyJSONMapping                   = @"name";
static NSString *const UserEmailPropertyJSONMapping                  = @"email";
static NSString *const UserGenderPropertyJSONMapping                 = @"gender";
static NSString *const UserPhonePropertyJSONMapping                  = @"phone";
static NSString *const UserAddressStreetPropertyJSONMapping          = @"street";
static NSString *const UserAddressHouseNumberPropertyJSONMapping     = @"house_number";
static NSString *const UserAddressCityPropertyJSONMapping            = @"city";
static NSString *const UserAddressPostalCodePropertyJSONMapping      = @"zip";

/**
 * User gender type.
 */
typedef NS_ENUM(NSInteger, UserGender) {
    UserGenderMale,
    UserGenderFemale
};

/**
 * Singleton class representing user using the app.
 */
@interface User : BFJSONSerializableObject <NSCoding>
/**
 * User unique identification number.
 */
@property (strong, nullable) NSNumber *identification;
/**
 * User unique remote identification number.
 */
@property (strong, nullable) NSNumber *remoteIdentification;
/**
 * User unique facebook identification number.
 */
@property (copy, nullable) NSString *facebookIdentification;
/**
 * User name and surname.
 */
@property (copy, nullable) NSString *name;
/**
 * User e-mail address.
 */
@property (copy, nullable) NSString *email;
/**
 * User gender.
 */
@property (assign) UserGender gender;
/**
 * User telephone number.
 */
@property (copy, nullable) NSString *phone;
/**
 * User street address.
 */
@property (copy, nullable) NSString *addressStreet;
/**
 * User address house number.
 */
@property (copy, nullable) NSString *addressHouseNumber;
/**
 * User address city.
 */
@property (copy, nullable) NSString *addressCity;
/**
 * User address postal code.
 */
@property (copy, nullable) NSString *addressPostalCode;

/**
 * Checks whether the user is currently logged in.
 * @return TRUE if the user is logged in, else FALSE.
 */
+ (BOOL)isLoggedIn;

/**
 * Translates user gender to its API name.
 *
 * @param gender The user gender.
 * @return The user gender API name.
 */
+ (nullable NSString *)userGenderAPIName:(UserGender)gender;

/**
 * Class method to access the static user instance.
 *
 * @return Singleton instance of the `User` class.
 */
+ (User *)sharedUser;

/**
 * Saves user to the local storage.
 */
- (void)saveUser;

/**
 * Logs user out.
 */
- (void)logout;

@end

NS_ASSUME_NONNULL_END
