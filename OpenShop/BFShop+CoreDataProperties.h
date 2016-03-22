//
//  BFShop+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFShop.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFShop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *shopID;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *flagIcon;
@property (nullable, nonatomic, retain) NSString *googleUA;
@property (nullable, nonatomic, retain) NSString *language;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
