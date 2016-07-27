//
//  BFCrashLoggerService.m
//  OpenShop
//
//  Created by Petr Škorňok on 01.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFCrashLoggerService.h"
// #import <CrashlyticsLumberjack/CrashlyticsLogger.h>
#import "BFAppLogger.h"

// @import Fabric;
// @import Crashlytics;

@implementation BFCrashLoggerService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Fabric initialization
//    [Fabric with:@[[Crashlytics class]]];

    // Add Crashlytics logger to CocoaLumberjack
//    [BFAppLogger addLogger:[CrashlyticsLogger sharedInstance]];

    return YES;
}

@end
