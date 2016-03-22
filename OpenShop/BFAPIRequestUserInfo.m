//
//  BFAPIRequestUserInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAPIRequestUserInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFAPIRequestUserInfoEmailPropertyName                         = @"email";
static NSString *const BFAPIRequestUserInfoPasswordPropertyName                      = @"password";
static NSString *const BFAPIRequestUserInfoPasswordOldPropertyName                   = @"passwordOld";
static NSString *const BFAPIRequestUserInfoPasswordNewPropertyName                   = @"passwordNew";
static NSString *const BFAPIRequestUserInfoGenderPropertyName                        = @"gender";
static NSString *const BFAPIRequestUserInfoFacebookIDPropertyName                    = @"facebookID";
static NSString *const BFAPIRequestUserInfoFacebookAccessTokenPropertyName           = @"facebookAccessToken";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFAPIRequestUserInfoEmailPropertyJSONMapping                  = @"email";
static NSString *const BFAPIRequestUserInfoPasswordPropertyJSONMapping               = @"password";
static NSString *const BFAPIRequestUserInfoPasswordOldPropertyJSONMapping            = @"old_password";
static NSString *const BFAPIRequestUserInfoPasswordNewPropertyJSONMapping            = @"new_password";
static NSString *const BFAPIRequestUserInfoGenderPropertyJSONMapping                 = @"gender";
static NSString *const BFAPIRequestUserInfoFacebookIDPropertyJSONMapping             = @"fb_id";
static NSString *const BFAPIRequestUserInfoFacebookAccessTokenPropertyJSONMapping    = @"fb_access_token";


@interface BFAPIRequestUserInfo ()

@end


@implementation BFAPIRequestUserInfo


#pragma mark - Initialization

-(instancetype)initWithEmail:(NSString *)email
                    password:(NSString *)password {
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
    }
    return self;
}

-(instancetype)initWithOldPassword:(NSString *)passwordOld
                       newPassword:(NSString *)passwordNew {
    self = [super init];
    if (self) {
        _passwordOld = passwordOld;
        _passwordNew = passwordNew;
    }
    return self;
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFAPIRequestUserInfoEmailPropertyName                  : BFAPIRequestUserInfoEmailPropertyJSONMapping,
             BFAPIRequestUserInfoPasswordPropertyName               : BFAPIRequestUserInfoPasswordPropertyJSONMapping,
             BFAPIRequestUserInfoPasswordOldPropertyName            : BFAPIRequestUserInfoPasswordOldPropertyJSONMapping,
             BFAPIRequestUserInfoPasswordNewPropertyName            : BFAPIRequestUserInfoPasswordNewPropertyJSONMapping,
             BFAPIRequestUserInfoGenderPropertyName                 : BFAPIRequestUserInfoGenderPropertyJSONMapping,
             BFAPIRequestUserInfoFacebookIDPropertyName             : BFAPIRequestUserInfoFacebookIDPropertyJSONMapping,
             BFAPIRequestUserInfoFacebookAccessTokenPropertyName    : BFAPIRequestUserInfoFacebookAccessTokenPropertyJSONMapping,
             };
}




@end
