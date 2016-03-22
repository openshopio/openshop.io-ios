//
//  BFProductVariantSizeParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductVariantSizeParsedResult.h"
#import "BFProductVariantSize.h"


@interface BFProductVariantSizeParsedResult ()


@end



@implementation BFProductVariantSizeParsedResult


#pragma mark - Initialization

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    return [BFProductVariantSize class];
    
}

@end



