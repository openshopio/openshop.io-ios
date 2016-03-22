//
//  BFOrderShippingParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFOrderShippingParsedResult.h"
#import "BFOrderShipping.h"


@interface BFOrderShippingParsedResult ()


@end



@implementation BFOrderShippingParsedResult


#pragma mark - Initialization

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    return [BFOrderShipping class];
}


@end



