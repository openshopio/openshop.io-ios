//
//  BFSpotlightService.m
//  OpenShop
//
//  Created by Petr Škorňok on 14.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import CoreSpotlight;
@import MobileCoreServices;

#import "BFCoreSpotlightService.h"
#import "BFProduct.h"

@implementation BFCoreSpotlightService

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        NSString* uniqueIdentifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        
        // Handle 'uniqueIdentifier'
        NSLog(@"uniqueIdentifier: %@", uniqueIdentifier);
    }
    
    return YES;
}

//- (void)indexSearchableProduct:(BFProduct *)product

@end
