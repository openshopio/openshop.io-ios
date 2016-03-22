//
//  BFProductBrandParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductBrandParsedResult.h"
#import "BFProductBrand.h"


@interface BFProductBrandParsedResult ()


@end



@implementation BFProductBrandParsedResult


#pragma mark - Initialization

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    return [BFProductBrand class];
    
}


@end



