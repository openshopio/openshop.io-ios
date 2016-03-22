//
//  BFAPIPath.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAPIPath.h"
#import "BFAppPreferences.h"



@interface BFAPIPath () {

}

@end


@implementation BFAPIPath


#pragma mark - Base API Paths

+ (NSString *)APIBaseURL {
    return [NSString stringWithFormat:@"%@", BFAPIRootURL];
}

+ (NSString *)APIBaseURLWithVersion:(NSString *)version {
    if(!version) {
        version = BFAPIDefaultVersion;
    }
    // base URL = API root + API version
    return [NSString stringWithFormat:@"%@/%@", BFAPIRootURL, version];
}

+ (NSString *)APIBaseURLWithPath:(NSString *)path params:(NSArray *)params {
    return [NSString stringWithFormat:@"%@/%@/%@", [self APIBaseURLWithVersion:BFAPIDefaultVersion], path, [params componentsJoinedByString:@"/"]];
}

+ (NSString *)APIBaseURLWithPath:(NSString *)path params:(NSArray *)params relative:(BOOL)relative {
    return relative ? [NSString stringWithFormat:@"%@/%@", path, [params componentsJoinedByString:@"/"]] : [self APIBaseURLWithPath:path params:params];
}

+ (NSString *)APIBaseURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params {
    return [NSString stringWithFormat:@"%@/%@/%@", [self APIBaseURLWithVersion:version], path, [params componentsJoinedByString:@"/"]];
}

+ (NSString *)APIBaseURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params relative:(BOOL)relative {
    return relative ? [NSString stringWithFormat:@"%@/%@/%@", version, path, [params componentsJoinedByString:@"/"]] : [self APIBaseURLWithPath:path version:version params:params];
}


#pragma mark - Shop API Paths

+ (NSString *)APIShopURL {
    return [self APIShopURLWithVersion:BFAPIDefaultVersion];
}

+ (NSString *)APIShopURLWithVersion:(NSString *)version {
    return [NSString stringWithFormat:@"%@/%@", version, [[BFAppPreferences sharedPreferences]selectedShop]];
}

+ (NSString *)APIRequestShopURLWithVersion:(NSString *)version relative:(BOOL)relative {
    return relative ? [self APIShopURLWithVersion:version] : [NSString stringWithFormat:@"%@/%@", [self APIBaseURLWithVersion:version], [[BFAppPreferences sharedPreferences]selectedShop]];
}

+ (NSString *)APIRequestShopURLWithPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@/%@", [self APIShopURL], path];
}

+ (NSString *)APIRequestShopURLWithPath:(NSString *)path params:(NSArray *)params {
    return params.count ? [NSString stringWithFormat:@"%@/%@/%@", [self APIShopURL], path, [params componentsJoinedByString:@"/"]] : [self APIRequestShopURLWithPath:path];
}

+ (NSString *)APIRequestShopURLWithPath:(NSString *)path version:(NSString *)version relative:(BOOL)relative {
    return [NSString stringWithFormat:@"%@/%@", [self APIRequestShopURLWithVersion:version relative:relative], path];
}

+ (NSString *)APIRequestShopURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params relative:(BOOL)relative {
    return params.count ? [NSString stringWithFormat:@"%@/%@/%@", [self APIRequestShopURLWithVersion:version relative:relative], path, [params componentsJoinedByString:@"/"]] : [self APIRequestShopURLWithPath:path version:version relative:relative];
}


#pragma mark - Organization API Paths

+ (NSString *)APIOrganizationURL {
    return [self APIOrganizationURLWithVersion:BFAPIDefaultVersion];
}

+ (NSString *)APIOrganizationURLWithVersion:(NSString *)version {
    return [NSString stringWithFormat:@"%@/%@", version, [[BFAppPreferences sharedPreferences]selectedOrganization]];
}

+ (NSString *)APIRequestOrganizationURLWithVersion:(NSString *)version relative:(BOOL)relative {
    return relative ? [self APIOrganizationURLWithVersion:version] : [NSString stringWithFormat:@"%@/%@", [self APIBaseURLWithVersion:version], [[BFAppPreferences sharedPreferences]selectedOrganization]];
}

+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@/%@", [self APIOrganizationURL], path];
}

+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path params:(NSArray *)params {
    return params.count ? [NSString stringWithFormat:@"%@/%@/%@", [self APIOrganizationURL], path, [params componentsJoinedByString:@"/"]] : [self APIRequestOrganizationURLWithPath:path];
}

+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path version:(NSString *)version relative:(BOOL)relative {
    return [NSString stringWithFormat:@"%@/%@", [self APIRequestOrganizationURLWithVersion:version relative:relative], path];
}

+ (NSString *)APIRequestOrganizationURLWithPath:(NSString *)path version:(NSString *)version params:(NSArray *)params relative:(BOOL)relative {
    return params.count ? [NSString stringWithFormat:@"%@/%@/%@", [self APIRequestOrganizationURLWithVersion:version relative:relative], path, [params componentsJoinedByString:@"/"]] : [self APIRequestOrganizationURLWithPath:path version:version relative:relative];
}


@end
