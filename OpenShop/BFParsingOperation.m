//
//  BFParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFParsingOperation.h"
#import "PersistentStorage.h"

@interface BFParsingOperation ()


@end


@implementation BFParsingOperation


#pragma mark - Initialization

- (instancetype)initWithRawData:(id)rawData completionBlock:(BFAPIDataLoadingCompletionBlock)completion {
    return [self initWithRawData:rawData managedObjectContext:[[StorageManager defaultManager] privateQueueContext] completionBlock:completion records:nil];
}

- (instancetype)initWithRawData:(id)rawData completionBlock:(BFAPIDataLoadingCompletionBlock)completion records:(NSArray *)records {
    return [self initWithRawData:rawData managedObjectContext:[[StorageManager defaultManager] privateQueueContext] completionBlock:completion records:records];
}

- (instancetype)initWithRawData:(id)rawData managedObjectContext:(NSManagedObjectContext *)managedObjectContext completionBlock:(BFAPIDataLoadingCompletionBlock) completion records:(NSArray *)records {
    self = [super init];
    if (self) {
        self.rawData = rawData;
        self.managedObjectContext = managedObjectContext;
        self.completion = completion;
        self.records = records;
    }
    return self;
}


@end



