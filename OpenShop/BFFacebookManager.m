//
//  BFFacebookManager.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFFacebookManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BFError.h"

/**
 * Facebook API login request read permissions.
 */
static NSString *const facebookAPILoginReadPermissions             = @"email";
/**
 * Facebook Graph API request path after login.
 */
static NSString *const facebookAPILoginGraphRequestPath            = @"me";
/**
 * Facebook Graph API request parameters key after login.
 */
static NSString *const facebookAPILoginGraphRequestParametersKey   = @"fields";
/**
 * Facebook Graph API request parameters value after login.
 */
static NSString *const facebookAPILoginGraphRequestParametersValue = @"id, name, email";


@interface BFFacebookManager () {

}

@end


@implementation BFFacebookManager


#pragma mark - Initialization

+ (instancetype)sharedManager {
    static BFFacebookManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    // execute initialization exactly once
    dispatch_once(&onceToken, ^{
        _sharedManager = [[BFFacebookManager alloc] init];
    });
    return _sharedManager;
}


#pragma mark - User Login

- (void)logInFromViewController:(UIViewController *)viewController withCompletionBlock:(BFFacebookCompletionBlock) block {
    // logout before login attempt
    [self logOut];

    [self logInWithReadPermissions:@[facebookAPILoginReadPermissions] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        // verify requested permissions
        if (error || result.isCancelled || ![result.grantedPermissions containsObject:facebookAPILoginReadPermissions]) {
            if (block) {
                block(nil, [BFError errorWithCode:BFErrorCodeFacebookLogin]);
            }
        } else {
            // retrieve user information
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:facebookAPILoginGraphRequestPath parameters:@{facebookAPILoginGraphRequestParametersKey : facebookAPILoginGraphRequestParametersValue}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (block) {
                        block((NSDictionary *)result, error);
                    }
                }];
            }
            else {
                if (block) {
                    block(nil, [BFError errorWithCode:BFErrorCodeFacebookLogin]);
                }
            }
        }
    }];
}



@end
