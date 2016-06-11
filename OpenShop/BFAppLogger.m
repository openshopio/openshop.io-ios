//
//  BFAppLogger.m
//  OpenShop
//
//  Created by Petr Škorňok on 05.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAppLogger.h"

#import <AFNetworkActivityLogger.h>
#import <AFNetworkActivityConsoleLogger.h>

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
    AFNetworkActivityConsoleLogger *logger = [AFNetworkActivityLogger sharedLogger].loggers.anyObject;
    logger.level = AFLoggerLevelDebug;
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    // CocoaLumberjack
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // MMRecord logging
    [MMRecord setLoggingLevel:MMRecordLoggingLevelInfo];
}

+ (void)setLogLevel:(DDLogLevel)logLevel {
    ddLogLevel = logLevel;
    AFNetworkActivityConsoleLogger *logger = [AFNetworkActivityLogger sharedLogger].loggers.anyObject;
    switch (logLevel) {
        case DDLogLevelOff:
            logger.level = AFLoggerLevelOff;
            break;
        case DDLogLevelError:
            logger.level = AFLoggerLevelError;
            break;
        case DDLogLevelInfo:
            logger.level = AFLoggerLevelInfo;
            break;
        case DDLogLevelDebug:
        case DDLogLevelWarning:
        case DDLogLevelVerbose:
        case DDLogLevelAll:
            logger.level = AFLoggerLevelDebug;
            break;
    }
}

+ (void)setColorsEnabled:(BOOL)colorsEnabled {
    setenv("XcodeColors", colorsEnabled ? "YES" : "NO", 0);
    [[DDTTYLogger sharedInstance] setColorsEnabled:colorsEnabled];
}

+ (void)addLogger:(id <DDLogger>)logger {
    [DDLog addLogger:logger];
}

@end
