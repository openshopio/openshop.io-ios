//
//  BFAPIRequestDeviceInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAPIRequestDeviceInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFAPIRequestDeviceInfoPlatformPropertyName                         = @"platform";
static NSString *const BFAPIRequestDeviceInfoDeviceTokenPropertyName                      = @"deviceToken";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFAPIRequestDeviceInfoPlatformPropertyJSONMapping                  = @"platform";
static NSString *const BFAPIRequestDeviceInfoDeviceTokenPropertyJSONMapping               = @"device_token";


@interface BFAPIRequestDeviceInfo ()

@end


@implementation BFAPIRequestDeviceInfo


#pragma mark - Initialization

- (instancetype)initWithPlatform:(NSString *)platform
                     deviceToken:(NSString *)deviceToken {
    self = [super init];
    if (self) {
        _platform = platform;
        _deviceToken = deviceToken;
    }
    return self;
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFAPIRequestDeviceInfoPlatformPropertyName    : BFAPIRequestDeviceInfoPlatformPropertyJSONMapping,
             BFAPIRequestDeviceInfoDeviceTokenPropertyName : BFAPIRequestDeviceInfoDeviceTokenPropertyJSONMapping,
             };
}




@end
