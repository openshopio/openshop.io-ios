//
//  BFAPIRequestDeviceInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAPIRequestDeviceInfo` encapsulates the device information information used in remote API communication.
 * It contains information required for device registration for push notifications.
 */
@interface BFAPIRequestDeviceInfo : BFJSONSerializableObject
/**
 * Device operating system platform.
 */
@property (copy, nullable) NSString *platform;
/**
 * Unique device identification number.
 */
@property (copy, nullable) NSString *deviceToken;


/**
 * Initializes a `BFAPIRequestDeviceInfo` object with device platform and unique identification.
 *
 * @param platform The device operating system platform.
 * @param deviceToken The device unique identification.
 * @return The newly-initialized `BFAPIRequestDeviceInfo`.
 */
- (instancetype)initWithPlatform:(NSString *)platform
                     deviceToken:(NSString *)deviceToken;


@end

NS_ASSUME_NONNULL_END
