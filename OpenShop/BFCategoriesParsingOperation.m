//
//  BFCategoriesParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCategoriesParsingOperation.h"
#import "BFCategoryParsedResult.h"
#import "BFCategory.h"

/**
 * The product category properties element key paths in a raw JSON data.
 */
static NSString *const BFCategoriesParsingRootElementKey     = @"navigation";
static NSString *const BFCategoriesParsingChildrenElementKey = @"children";



@interface BFCategoriesParsingOperation ()


@end


@implementation BFCategoriesParsingOperation


#pragma mark - Parsing

- (void)main {
    // categories
    NSArray *categoriesArray;
    if([self.rawData isKindOfClass:[NSArray class]]) {
        categoriesArray = (NSArray *)self.rawData;
    }
    else {
        categoriesArray = (NSArray *)[self.rawData objectForKey:BFCategoriesParsingRootElementKey];
    }

    // categories parsing
    [self.managedObjectContext performBlockAndWait:^{
        NSMutableArray *categories = [[NSMutableArray alloc]init];
        for (id categoryElem in categoriesArray) {
            // stop parsing if the operation has been cancelled
            if (self.isCancelled) {
                break;
            }
            // parse category
            if([categoryElem isKindOfClass:[NSDictionary class]]) {
                // category data model
                BFCategory *category = [BFCategoryParsedResult dataModelFromDictionary:categoryElem];
                
                // child categories
                if([categoryElem objectForKey:BFCategoriesParsingChildrenElementKey]) {
                    id childCategories = [categoryElem objectForKey:BFCategoriesParsingChildrenElementKey];
                    // parsing operation
                    BFCategoriesParsingOperation *operation = [[BFCategoriesParsingOperation alloc]initWithRawData:childCategories completionBlock:^(NSArray *records, id customResponse, NSError *error) {
                        if(!error) {
                            // set parent category
                            for (BFCategory *childCategory in records) {
                                childCategory.parent = category;
                            }
                            // children categories
                            category.children = [NSOrderedSet orderedSetWithArray:records];
                        }
                    }];
                    [operation start];
                }
                // save category
                [categories addObject:category];
            }
        }
        
        // save parsed records
        NSError *error;
        if ([self.managedObjectContext save:&error]) {
            if(self.completion) {
                self.completion(categories, nil, nil);
            }
        }
        else {
            if(self.completion) {
                self.completion(nil, nil, error);
            }
        }
    }];
}


@end



