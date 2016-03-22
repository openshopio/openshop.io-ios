//
//  BFAppLogger.m
//  OpenShop
//
//  Created by Petr Škorňok on 05.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAppLogger.h"

#import <ATNetworkActivityLoggerLumberJack/ATNetworkActivityLoggerLumberJack.h>

DDLogLevel ddLogLevel;

@implementation BFAppLogger

+ (void)startLogging
{
    #ifdef DEBUG
        [BFAppLogger startLoggingWithLevel:DDLogLevelDebug];
    #else
        [BFAppLogger startLoggingWithLevel:DDLogLevelInfo];
    #endif
}

+ (void)startLoggingWithLevel:(DDLogLevel)logLevel
{
    [BFAppLogger startLoggingWithLevel:logLevel colorsEnabled:NO];
}

+ (void)startLoggingWithLevel:(DDLogLevel)logLevel colorsEnabled:(BOOL)colorsEnabled
{
    [BFAppLogger setColorsEnabled:colorsEnabled];
    [BFAppLogger setLogLevel:logLevel];

    // AFNetworking logger
    [[ATNetworkActivityLoggerLumberJack sharedLogger] startLogging];
    
    // CocoaLumberjack
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // MMRecord logging
    [MMRecord setLoggingLevel:MMRecordLoggingLevelInfo];
}

+ (void)setLogLevel:(DDLogLevel)logLevel {
    ddLogLevel = logLevel;
    [[ATNetworkActivityLoggerLumberJack sharedLogger] setDdLogLevel:logLevel];
}

+ (void)setColorsEnabled:(BOOL)colorsEnabled {
    setenv("XcodeColors", colorsEnabled ? "YES" : "NO", 0);
    [[DDTTYLogger sharedInstance] setColorsEnabled:colorsEnabled];
}

+ (void)addLogger:(id <DDLogger>)logger {
    [DDLog addLogger:logger];
}

@end
