//
//  User.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "User.h"
#import "BFKeyStore.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"

/**
 * NSCoding user defaults keys to identify saved properties.
 */
static NSString *const UserDefaultsUserKey                           = @"User";
static NSString *const UserDefaultsUserIdentificationKey             = @"UserIdentification";
static NSString *const UserDefaultsUserRemoteIdentificationKey       = @"UserRemoteIdentification";
static NSString *const UserDefaultsUserFacebookIdentificationKey     = @"UserFacebookIdentification";
static NSString *const UserDefaultsUserNameKey                       = @"UserName";
static NSString *const UserDefaultsUserEmailKey                      = @"UserEmail";
static NSString *const UserDefaultsUserGenderKey                     = @"UserGender";
static NSString *const UserDefaultsUserPhoneKey                      = @"UserPhone";
static NSString *const UserDefaultsUserAddressStreetKey              = @"UserAddressStreet";
static NSString *const UserDefaultsUserAddressHouseNumberKey         = @"UserAddressHouseNumber";
static NSString *const UserDefaultsUserAddressCityKey                = @"UserAddressCity";
static NSString *const UserDefaultsUserAddressPostalCodeKey          = @"UserAddressPostalCode";


@interface User ()

@end


@implementation User


#pragma mark - Initialization

+ (User *)sharedUser {
    static User *sharedUser = nil;
    @synchronized(self)
    {
        if (sharedUser == nil)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsUserKey];
            if (data != nil)
            {
                sharedUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (sharedUser == nil)
                {
                    sharedUser = [[self alloc] init];
                }
                
            } else {
                sharedUser = [[self alloc] init];
            }
        }
    }
    return sharedUser;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - Persistence Management

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self)
    {
        self.identification = [aDecoder decodeObjectForKey:UserDefaultsUserIdentificationKey];
        self.remoteIdentification = [aDecoder decodeObjectForKey:UserDefaultsUserRemoteIdentificationKey];
        self.facebookIdentification = [aDecoder decodeObjectForKey:UserDefaultsUserFacebookIdentificationKey];
        self.name = [aDecoder decodeObjectForKey:UserDefaultsUserNameKey];
        self.email = [aDecoder decodeObjectForKey:UserDefaultsUserEmailKey];
        self.gender = [aDecoder decodeIntegerForKey:UserDefaultsUserGenderKey];
        self.phone = [aDecoder decodeObjectForKey:UserDefaultsUserPhoneKey];
        self.addressStreet = [aDecoder decodeObjectForKey:UserDefaultsUserAddressStreetKey];
        self.addressHouseNumber = [aDecoder decodeObjectForKey:UserDefaultsUserAddressHouseNumberKey];
        self.addressCity = [aDecoder decodeObjectForKey:UserDefaultsUserAddressCityKey];
        self.addressPostalCode = [aDecoder decodeObjectForKey:UserDefaultsUserAddressPostalCodeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identification forKey:UserDefaultsUserIdentificationKey];
    [aCoder encodeObject:self.remoteIdentification forKey:UserDefaultsUserRemoteIdentificationKey];
    [aCoder encodeObject:self.facebookIdentification forKey:UserDefaultsUserFacebookIdentificationKey];
    [aCoder encodeObject:self.name forKey:UserDefaultsUserNameKey];
    [aCoder encodeObject:self.email forKey:UserDefaultsUserEmailKey];
    [aCoder encodeInteger:self.gender forKey:UserDefaultsUserGenderKey];
    [aCoder encodeObject:self.phone forKey:UserDefaultsUserPhoneKey];
    [aCoder encodeObject:self.addressStreet forKey:UserDefaultsUserAddressStreetKey];
    [aCoder encodeObject:self.addressHouseNumber forKey:UserDefaultsUserAddressHouseNumberKey];
    [aCoder encodeObject:self.addressCity forKey:UserDefaultsUserAddressCityKey];
    [aCoder encodeObject:self.addressPostalCode forKey:UserDefaultsUserAddressPostalCodeKey];
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             UserIdentificationPropertyName         : UserIdentificationPropertyJSONMapping,
             UserRemoteIdentificationPropertyName   : UserRemoteIdentificationPropertyJSONMapping,
             UserFacebookIdentificationPropertyName : UserFacebookIdentificationPropertyJSONMapping,
             UserNamePropertyName                   : UserNamePropertyJSONMapping,
             UserEmailPropertyName                  : UserEmailPropertyJSONMapping,
             UserGenderPropertyName                 : UserGenderPropertyJSONMapping,
             UserPhonePropertyName                  : UserPhonePropertyJSONMapping,
             UserAddressStreetPropertyName          : UserAddressStreetPropertyJSONMapping,
             UserAddressHouseNumberPropertyName     : UserAddressHouseNumberPropertyJSONMapping,
             UserAddressCityPropertyName            : UserAddressCityPropertyJSONMapping,
             UserAddressPostalCodePropertyName      : UserAddressPostalCodePropertyJSONMapping,
             };
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           [self userGenderAPIName:UserGenderMale]   : @(UserGenderMale),
                                                                           [self userGenderAPIName:UserGenderFemale] : @(UserGenderFemale)
                                                                          }];
}


#pragma mark - Translation Names

+ (NSDictionary *)userGenderAPINames {
    return @{@(UserGenderMale)   : @"male",
             @(UserGenderFemale) : @"female"
             };
}


#pragma mark - Translations to Names

+ (NSString *)userGenderAPIName:(UserGender)gender {
    NSDictionary *APINames = [self userGenderAPINames];
    return gender < APINames.count ? APINames[@(gender)] : nil;
}


#pragma mark - User State Management

+ (BOOL)isLoggedIn {
    return [BFKeystore isLoggedIn];
}

- (void)saveUser {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:UserDefaultsUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFUserDidSaveNotification];
}

- (void)clearUser {
    // reset all user data
    self.identification = nil;
    self.remoteIdentification = nil;
    self.facebookIdentification = nil;
    self.name = nil;
    self.email = nil;
    self.gender = UserGenderFemale;
    self.phone = nil;
    self.addressStreet = nil;
    self.addressHouseNumber = nil;
    self.addressCity = nil;
    self.addressPostalCode = nil;
    // save changes
    [self saveUser];
}

- (void)logout {
    // clean up
    [self clearUser];
    [BFKeystore clearSavedCredentials];
    // notify with changes
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartWillSynchronizeNotification];
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFUserDidChangeNotification];//postNotificationName:BFUserDidChangeNotification object:nil];
    });
}


@end
