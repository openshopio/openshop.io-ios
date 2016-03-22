//
//  BFProductParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductParsedResult.h"
#import "BFProduct.h"


@interface BFProductParsedResult ()


@end



@implementation BFProductParsedResult


#pragma mark - Initialization

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    return [BFProduct class];
}


@end



