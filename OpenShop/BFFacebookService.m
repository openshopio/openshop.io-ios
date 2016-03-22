//
//  BFFacebookService.m
//  OpenShop
//
//  Created by Petr Škorňok on 11.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//  Docs adopted from: https://developers.facebook.com/docs

#import "BFFacebookService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Bolts.h>

@implementation BFFacebookService

/**
 * FBSDKApplicationDelegate application:didFinishLaunchingWithOptions should be invoked for the proper use of the Facebook SDK.
 * FBSDKAppLinkUtility fetchDeferredAppLink enables the app to handle deffered deep links.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL returnValue = [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
            if (error) {
                DDLogError(@"Received error while fetching deferred app link %@", error);
            }
            if (url) {
                DDLogInfo(@"URL launch");
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }
    return returnValue;
}

/**
 * FBSDKApplicationDelegate application:openURL:sourceApplication:annotation: should be invoked for
 * the proper processing of responses during interaction with the native Facebook app or Safari
 * as part of SSO authorization flow or Facebook dialogs.
 *
 * BFURL provides easy to use APIs to help you to parse the incoming URL.
 */
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    return [self handleOpenApplication:application url:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark Support for iOS 9 and higher

- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString*, id>*)options
{
    NSString* sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    id annotation = options[UIApplicationOpenURLOptionsAnnotationKey];
    
    return [self handleOpenApplication:app url:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)handleOpenApplication:(UIApplication*)app url:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    BFURL* parsedUrl = [BFURL URLWithInboundURL:url sourceApplication:sourceApplication];
    
    if (parsedUrl.appLinkData) {
        DDLogInfo(@"Applink Data: %@", [parsedUrl appLinkData]);
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

/**
 * Calling activateApp enables logging app activations.
 * By logging an activation event, you can observe how frequently users activate your app,
 * how much time they spend using it, and view other demographic information through Facebook Analytics for Apps.
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    [FBSDKSettings setLoggingBehavior:[NSSet setWithObjects:FBSDKLoggingBehaviorDeveloperErrors, nil]];
}

@end
