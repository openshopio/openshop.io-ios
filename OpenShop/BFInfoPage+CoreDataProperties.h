//
//  BFInfoPage+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFInfoPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFInfoPage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *pageID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *text;

@end

NS_ASSUME_NONNULL_END
