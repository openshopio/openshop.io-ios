//
//  BFSearchSuggestion+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 16.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BFSearchSuggestion.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFSearchSuggestion (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *searchSuggestionID;
@property (nullable, nonatomic, retain) NSString *suggestion;

@end

NS_ASSUME_NONNULL_END
