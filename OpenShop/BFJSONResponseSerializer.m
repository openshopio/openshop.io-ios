//
//  BFJSONResponseSerializer.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFJSONResponseSerializer.h"
#import "User.h"

/**
 * HTTP response unauthorized status code.
 */
static NSInteger const APIResponseUnauthorizedStatusCode = 401;
/**
 * HTTP response forbidden status code.
 */
static NSInteger const APIResponseForbiddenStatusCode    = 403;

@implementation BFJSONResponseSerializer


#pragma mark - Status Code Examination

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {

    if ([[self clientErrorStatusCodes]containsObject:@(((NSHTTPURLResponse*)response).statusCode)]) {
        [[User sharedUser] logout];
    }
    
    return [super responseObjectForResponse:response data:data error:error];
}

- (NSArray<NSNumber*> *)clientErrorStatusCodes {
    return @[
             @(APIResponseUnauthorizedStatusCode),
             @(APIResponseForbiddenStatusCode)
            ];
}

@end
