//
//  BFAppLogger.h
//  OpenShop
//
//  Created by Petr Škorňok on 05.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 * CocoaLumberjack logging level.
 */
extern DDLogLevel ddLogLevel;

/**
 * `BFAppLogger` provides information of application preferences.
 * It is intended to be modified by user and to save important info of
 * his app customization requests.
 */
@interface BFAppLogger : NSObject 

/**
 * Enable logger with log level and colorsEnabled based on the
 * information if the application is build as DEBUG or RELEASE.
 */
+ (void)startLogging;

/**
 * Enable logger with specified log level and colorsEnabled set to NO.
 */
+ (void)startLoggingWithLevel:(DDLogLevel)logLevel;

/**
 * Enable logger with specified log level and colorsEnabled.
 */
+ (void)startLoggingWithLevel:(DDLogLevel)level colorsEnabled:(BOOL)colorsEnabled;

/**
 * Log level custom setter.
 */
+ (void)setLogLevel:(DDLogLevel)logLevel;

/**
 * Colors enabled custom setter.
 */
+ (void)setColorsEnabled:(BOOL)logLevel;
/**
 * Add logger.
 */
+ (void)addLogger:(id <DDLogger>)logger;

@end

NS_ASSUME_NONNULL_END
