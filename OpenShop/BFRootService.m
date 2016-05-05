//
//  BFRootService.m
//  OpenShop
//
//  Created by Petr Škorňok on 11.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFRootService.h"
#import "BFAppSessionInfo.h"
#import "BFKeystore.h"
#import "BFAppAppearance.h"
#import "BFAPIManager.h"
#import "BFAppPreferences.h"
#import "BFAppStructure.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"

#ifdef DEBUG
#import <SDStatusBarManager.h>
#endif

@implementation BFRootService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // clear saved credentials from previous app installs
    if([[BFAppSessionInfo sharedInfo]firstLaunch]) {
        [BFKeystore clearSavedCredentials];
    }
    
    // app appearance
    [BFAppAppearance customizeAppearance:false];
    
    
    [[BFAPIManager sharedManager]findTranslationsCompletionBlock:nil];
    [[NSNotificationCenter defaultCenter]addObserverForName:BFLanguageDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *note) {
        [[BFAPIManager sharedManager]findTranslationsCompletionBlock:nil];
    }];
        
    // app logging
    [BFAppLogger startLogging];
    
    // clean staus bar for screenshots
    #ifdef DEBUG
        [[SDStatusBarManager sharedInstance] enableOverrides];
    #endif

    return YES;
}

@end
