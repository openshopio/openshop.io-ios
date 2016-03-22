//
//  BFTranslation+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTranslation.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFTranslation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stringID;
@property (nullable, nonatomic, retain) NSString *language;
@property (nullable, nonatomic, retain) NSString *value;

@end

NS_ASSUME_NONNULL_END
