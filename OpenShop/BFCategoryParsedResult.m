//
//  BFCategoryParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFCategoryParsedResult.h"
#import "BFCategory.h"


@interface BFCategoryParsedResult ()


@end



@implementation BFCategoryParsedResult


#pragma mark - BFParsedResult Customization

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    return [BFCategory class];
}


@end



