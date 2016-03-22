//
//  BFServicesDispatcher.h
//  OpenShop
//
//  Created by Petr Škorňok on 11.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFServicesDispatcher` handles delegating calls to
 * all available services.
 */
@interface BFServicesDispatcher : NSObject <UIApplicationDelegate>

/**
 * `BFServicesDispatcher` initializer. 
 * @param services serves for defining which services the app should use.
 * @return instance of `BFServicesDispatcher` class
 */
- (instancetype)initWithServices:(NSArray<id<UIApplicationDelegate>> *)services;

/**
 * Performs the selector with the given arguments.
 */
- (void)performSelector:(SEL)selector sender:(id)sender withArguments:(NSArray *)arguments;

/**
 * Performs the selector with the given arguments returning BOOL.
 */
- (BOOL)performBOOLSelector:(SEL)selector sender:(id)sender withArguments:(NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
