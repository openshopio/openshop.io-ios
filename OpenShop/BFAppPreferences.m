//
//  BFAppPreferences.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppPreferences.h"
#import "BFAppStructure.h"
#import "User.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "BFAppStructure.h"

/**
 * NSCoding user defaults keys to identify saved properties.
 */
static NSString *const UserDefaultsAppPreferencesKey                    = @"AppPreferences";
static NSString *const UserDefaultsAppPreferencesSelectedShopKey        = @"SelectedShop";
static NSString *const UserDefaultsAppPreferencesSelectedLanguageKey    = @"SelectedLanguage";
static NSString *const UserDefaultsAppPreferencesSelectedOrganization   = @"SelectedOrganization";
static NSString *const UserDefaultsAppPreferencesAPNIdentification      = @"APNIdentification";
static NSString *const UserDefaultsAppPreferencesPreferredViewType      = @"PreferredViewType";
static NSString *const UserDefaultsAppPreferencesPreferredSortType      = @"PreferredSortType";
static NSString *const UserDefaultsAppPreferencesPreferredMenuCategory  = @"PreferredMenuCategory";

/**
 * Default organization identification.
 */
static NSInteger const BFAppPreferencesDefaultOrganization        = 4;
/**
 * Default shop identification.
 */
static BFShopIdentification const BFAppPreferencesDefaultShop     = BFShopIdentificationOpenShop;
/**
 * Default shop language.
 */
static NSString *const BFAppPreferencesDefaultLanguage = @"en";
/**
 * Default products view type.
 */
static BFViewType const BFAppPreferencesDefaultViewType           = BFViewTypeCollection;
/**
 * Default products sort type.
 */
static BFSortType const BFAppPreferencesDefaultSortType           = BFSortTypeNewest;
/**
 * Default products menu category.
 */
static BFMenuCategory const BFAppPreferencesDefaultMenuCategory   = BFMenuCategoryNone;


@implementation BFAppPreferences

/**
 * Synthesized properties with overriden getters and setters.
 */
@synthesize selectedShop           = _selectedShop;
@synthesize selectedLanguage       = _selectedLanguage;
@synthesize preferredMenuCategory  = _preferredMenuCategory;
@synthesize selectedOrganization   = _selectedOrganization;
@synthesize preferredViewType      = _preferredViewType;
@synthesize preferredSortType      = _preferredSortType;


#pragma mark - Initialization

+ (BFAppPreferences *)sharedPreferences {
    static BFAppPreferences *sharedPreferences = nil;
    @synchronized(self)
    {
        if (sharedPreferences == nil)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsAppPreferencesKey];
            if (data != nil)
            {
                sharedPreferences = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (sharedPreferences == nil)
                {
                    sharedPreferences = [[self alloc] init];
                }
                
            } else {
                sharedPreferences = [[self alloc] init];
            }
        }
    }
    return sharedPreferences;
}

- (id)init {
    self = [super init];
    if (self) {
        [self resetPreferences];
    }
    return self;
}


#pragma mark - Persistence Management

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self)
    {
        _selectedShop = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesSelectedShopKey];
        _selectedLanguage = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesSelectedLanguageKey];
        _selectedOrganization = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesSelectedOrganization];
        _APNIdentification = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesAPNIdentification];
        _preferredViewType = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesPreferredViewType];
        _preferredSortType = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesPreferredSortType];
        _preferredMenuCategory = [aDecoder decodeObjectForKey:UserDefaultsAppPreferencesPreferredMenuCategory];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.selectedShop forKey:UserDefaultsAppPreferencesSelectedShopKey];
    [aCoder encodeObject:self.selectedLanguage forKey:UserDefaultsAppPreferencesSelectedLanguageKey];
    [aCoder encodeObject:self.selectedOrganization forKey:UserDefaultsAppPreferencesSelectedOrganization];
    [aCoder encodeObject:self.APNIdentification forKey:UserDefaultsAppPreferencesAPNIdentification];
    [aCoder encodeObject:self.preferredViewType forKey:UserDefaultsAppPreferencesPreferredViewType];
    [aCoder encodeObject:self.preferredSortType forKey:UserDefaultsAppPreferencesPreferredSortType];
    [aCoder encodeObject:self.preferredMenuCategory forKey:UserDefaultsAppPreferencesPreferredMenuCategory];
}

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:UserDefaultsAppPreferencesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetPreferences {
    self.selectedShop = @(BFAppPreferencesDefaultShop);
    self.selectedLanguage = BFAppPreferencesDefaultLanguage;
    self.selectedOrganization = @(BFAppPreferencesDefaultOrganization);
    self.APNIdentification = nil;
    self.preferredViewType = @(BFAppPreferencesDefaultViewType);
    self.preferredSortType = @(BFAppPreferencesDefaultSortType);
    self.preferredMenuCategory = @(BFAppPreferencesDefaultMenuCategory);
    [self save];
}


#pragma mark - Preferences Getters

- (NSNumber *)selectedShop {
    // if none selected return default
    if (!_selectedShop) {
        _selectedShop = @(BFAppPreferencesDefaultShop);
    }
    return _selectedShop;
}

- (NSNumber *)selectedOrganization {
    // if none selected return default
    if (!_selectedOrganization) {
        _selectedOrganization = @(BFAppPreferencesDefaultOrganization);
    }
    return _selectedOrganization;
}

- (NSNumber *)preferredViewType {
    // if none selected return default
    if (!_preferredViewType) {
        _preferredViewType = @(BFAppPreferencesDefaultViewType);
    }
    return _preferredViewType;
}

- (NSNumber *)preferredSortType {
    // if none selected return default
    if (!_preferredSortType) {
        _preferredSortType = @(BFAppPreferencesDefaultSortType);
    }
    return _preferredSortType;
}

- (NSNumber *)preferredMenuCategory {
    // if none selected return default
    if (!_preferredMenuCategory) {
        _preferredMenuCategory = @(BFAppPreferencesDefaultMenuCategory);
    }
    return _preferredMenuCategory;
}


#pragma mark - Preferences Modification

- (void)setSelectedShop:(NSNumber *)selectedShop {
    _selectedShop = selectedShop;
    
    // if the user is logged in re-login him in the new shop
    if ([User isLoggedIn]) {
        [[User sharedUser] logout];
    }

    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFLanguageDidChangeNotification];
    // update shopping cart badge value
    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartWillSynchronizeNotification];
    [self save];
}

- (void)setSelectedLanguage:(NSString *)selectedLanguage {
    _selectedLanguage = selectedLanguage;
    [self save];
}

- (void)setSelectedOrganization:(NSNumber *)selectedOrganization {
    _selectedOrganization = selectedOrganization;
    [self save];
}

- (void)setAPNIdentification:(NSString *)APNIdentification {
    _APNIdentification = APNIdentification;
    [self save];
}

- (void)setPreferredMenuCategory:(NSNumber *)preferredMenuCategory {
    _preferredMenuCategory = preferredMenuCategory;
    [self save];
}

- (void)setPreferredViewType:(NSNumber *)preferredViewType {
    _preferredViewType = preferredViewType;
    [self save];
}

- (void)setPreferredSortType:(NSNumber *)preferredSortType {
    _preferredSortType = preferredSortType;
    [self save];
}


@end
