//
//  BFGoogleService.m
//  OpenShop
//
//  Created by Petr Škorňok on 27.07.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFGoogleService.h"
#import <Google/Analytics.h>

@implementation BFGoogleService

/**
 * Configure GGLContext.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    GAI *gai = [GAI sharedInstance];
    
    // Optional: configure GAI options.
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelError;

    return YES;
}


@end
