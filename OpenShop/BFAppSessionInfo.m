//
//  BFAppSessionInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppSessionInfo.h"

/**
 * NSCoding user defaults keys to identify saved properties.
 */
static NSString *const UserDefaultsAppSessionInfoKey = @"AppSessionInfo";
static NSString *const UserDefaultsAppSessionInfoFirstLaunchKey = @"FirstLaunch";
static NSString *const UserDefaultsNotificationsPermissionsAsked        = @"NotificationsPermissionsAsked";


@implementation BFAppSessionInfo


#pragma mark - Initialization

+ (BFAppSessionInfo *)sharedInfo
{
    static BFAppSessionInfo *sharedInfo = nil;
    @synchronized(self)
    {
        if (sharedInfo == nil)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsAppSessionInfoKey];
            if (data != nil)
            {
                sharedInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (sharedInfo == nil)
                {
                    sharedInfo = [[self alloc] init];
                }
                
            } else {
                sharedInfo = [[self alloc] init];
            }
        }
    }
    return sharedInfo;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self resetSessionInfo];
    }
    return self;
}


#pragma mark - Persistence Management

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        _firstLaunch = [aDecoder decodeBoolForKey:UserDefaultsAppSessionInfoFirstLaunchKey];
        _askedForPushNotificationsPermissions = [aDecoder decodeBoolForKey:UserDefaultsNotificationsPermissionsAsked];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.firstLaunch forKey:UserDefaultsAppSessionInfoFirstLaunchKey];
    [aCoder encodeBool:self.askedForPushNotificationsPermissions forKey:UserDefaultsNotificationsPermissionsAsked];
}

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:UserDefaultsAppSessionInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetSessionInfo
{
    self.firstLaunch = true;
    self.askedForPushNotificationsPermissions = false;
    [self save];
}


#pragma mark - Session Info Modification

- (void)setFirstLaunch:(BOOL)firstLaunch {
    if(_firstLaunch != firstLaunch) {
        _firstLaunch = firstLaunch;
        [self save];
    }
}

- (void)setAskedForPushNotificationsPermissions:(BOOL)askedForPushNotificationsPermissions {
    if(_askedForPushNotificationsPermissions != askedForPushNotificationsPermissions) {
        _askedForPushNotificationsPermissions = askedForPushNotificationsPermissions;
        [self save];
    }
}

#pragma mark - Application Info

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"];
}

+ (NSString *)build {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
}

+ (NSString *)versionBuild {
    NSString * version = [self appVersion];
    NSString * build = [self build];
    NSString * versionBuild = nil;
    
    if(version) {
        versionBuild = [NSString stringWithFormat: @"v%@", version];
    }
    if (build && ![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}


#pragma mark - Device Info

+ (NSString *)deviceToken {
    NSUUID *deviceToken = [[UIDevice currentDevice] identifierForVendor];
    return [deviceToken UUIDString];
}

+ (NSString *)currentLanguage {
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    NSArray *items = [language componentsSeparatedByString:@"-"];
    // ios 9 might return locale identifier (en-us)
    if([items count] == 2) {
        return [items firstObject];
    }
    return language;
}


@end
