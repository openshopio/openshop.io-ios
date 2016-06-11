//
//  BFXMLRequestSerializer.h
//  OpenShop
//
//  Created by Petr Škorňok on 11.06.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFXMLRequestSerializer` subclasses `AFHTTPRequestSerializer` to customize the request body.
 */
@interface BFXMLRequestSerializer : AFHTTPRequestSerializer <AFURLRequestSerialization>

@end

NS_ASSUME_NONNULL_END
