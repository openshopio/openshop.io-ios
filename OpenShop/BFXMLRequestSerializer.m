//
//  BFXMLRequestSerializer.m
//  OpenShop
//
//  Created by Petr Škorňok on 11.06.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFXMLRequestSerializer.h"

@implementation BFXMLRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error {
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    [mutableRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if ([parameters isKindOfClass:[NSString class]]) {
        mutableRequest.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return mutableRequest;
}

@end
