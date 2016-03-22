//
//  BFProductVariantColorParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductVariantColorParsedResult.h"
#import "BFProductVariantColor.h"


@interface BFProductVariantColorParsedResult ()


@end



@implementation BFProductVariantColorParsedResult


#pragma mark - Initialization

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    return [BFProductVariantColor class];
}



@end



