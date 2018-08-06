//
//  BFGoogleService.m
//  OpenShop
//
//  Created by Petr Škorňok on 27.07.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Firebase;

#import "BFGoogleService.h"

@implementation BFGoogleService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Enable the following line once you add GoogleService-Info.plist from your Firebase console
    [FIRApp configure];

    return YES;
}


@end
