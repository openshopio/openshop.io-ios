//
//  BFJSONRequestSerializer.m
//  OpenShop
//
//  Created by Petr Škorňok on 11.06.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFJSONRequestSerializer.h"
#import "BFAppSessionInfo.h"

/**
 * API service request header key to identify client.
 */
static NSString *const APIRequestHeaderClientVersion    = @"Client-Version";
/**
 * API service request header key to identify device.
 */
static NSString *const APIRequestHeaderDeviceToken      = @"Device-Token";

@implementation BFJSONRequestSerializer

- (instancetype)init {
    if ((self = [super init])) {
        self.writingOptions = NSJSONWritingPrettyPrinted;
        [self setValue:[BFAppSessionInfo versionBuild] forHTTPHeaderField:APIRequestHeaderClientVersion];
        [self setValue:[BFAppSessionInfo deviceToken] forHTTPHeaderField:APIRequestHeaderDeviceToken];
    }
    return self;
}

@end
