//
//  PersistentStorage.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "PersistentStorage.h"


/**
 * Core data managed object model file name.
 */
static NSString *const managedObjectModelFileName = @"DataModelv2.momd";
/**
 * Core data persistent storage file name.
 */
static NSString *const persistentStoreFileName    = @"db.sqlite";



@interface PersistentStorage ()

/**
 * The persistent store coordinator (associates persistent store with a model).
 */
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
/**
 * The managed object model (describes storage schema).
 */
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end


@implementation PersistentStorage


#pragma mark - Inititialization

+ (instancetype)defaultStorage {
    static PersistentStorage *sharedStorage = nil;
    static dispatch_once_t onceToken;
    
    // execute initialization exactly once
    dispatch_once(&onceToken, ^{
        sharedStorage = [[PersistentStorage alloc] init];
    });
    return sharedStorage;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}


#pragma mark - Private Getters

- (NSManagedObjectContext *)mainQueueContext {
    return [[StorageManager defaultManager] mainQueueContext];
}

- (NSManagedObjectContext *)privateQueueContext {
    return [[StorageManager defaultManager] privateQueueContext];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        // init with managed object model
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        // setup persistent store with options
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&error];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        // load core data compiled storage schema
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[managedObjectModelFileName stringByDeletingPathExtension] withExtension:[managedObjectModelFileName pathExtension]];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSString *)managedObjectModelFileName {
    return managedObjectModelFileName;
}

- (NSURL *)persistentStoreURL {
    // app name and its support directory
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(__bridge NSString *)kCFBundleNameKey];
    NSURL *appSupportDirectory = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    // creates subfolder in app support directory
    NSURL *storageDirectory = [appSupportDirectory URLByAppendingPathComponent:appName isDirectory:true];
    NSString *storageDirectoryPath = [storageDirectory path];
    [[NSFileManager defaultManager] createDirectoryAtPath:storageDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    // exclude item from iCloud backup
    [storageDirectory setResourceValue: [NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    // append persistent store file name
    return [storageDirectory URLByAppendingPathComponent:persistentStoreFileName];
}

- (NSDictionary *)persistentStoreOptions {
    // synchronous for the fastest processing
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}


#pragma mark - Context queues & Managed objects

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString {
    NSURL *managedObjectIDURL = [NSURL URLWithString:managedObjectIDString];
    return [[[self defaultStorage] persistentStoreCoordinator] managedObjectIDForURIRepresentation:managedObjectIDURL];
}


#pragma mark - Persistent Storage Modification

- (void)clearDB {
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    NSArray* stores = [coordinator persistentStores];
    for (NSPersistentStore* store in stores) {
        // remove storage from coordinator
        [coordinator removePersistentStore:store error:nil];
        NSString *storagePath = store.URL.path;
        if(storagePath) {
            // remove persistent storage file
            [[NSFileManager defaultManager] removeItemAtPath:storagePath error:nil];
        }
    }
    
    _persistentStoreCoordinator = nil;
}


@end
