//
//  BFProductFiltersParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductFiltersParsingOperation.h"
#import "BFParsedResult.h"
#import "BFProductFilterTypeParsingOperation.h"

/**
 * The product filters element key path in a raw JSON data.
 */
static NSString *const BFFiltersParsingRootElementKey = @"metadata.filters";


@interface BFProductFiltersParsingOperation ()


@end


@implementation BFProductFiltersParsingOperation


#pragma mark - Parsing

- (void)main {
    // filters
    NSArray *filterTypesArray = (NSArray *)[self.rawData valueForKeyPath:BFFiltersParsingRootElementKey];
    if(filterTypesArray) {
        // filters parsing
        NSMutableArray *filters = [[NSMutableArray alloc]init];
        for (id filterTypeElem in filterTypesArray) {
            // stop parsing if the operation has been cancelled
            if (self.isCancelled) {
                break;
            }
            // parse filter type
            if([filterTypeElem isKindOfClass:[NSDictionary class]]) {
                BFProductFilterTypeParsingOperation *operation = [[BFProductFilterTypeParsingOperation alloc]initWithRawData:filterTypeElem completionBlock:^(NSArray *records, id customResponse, NSError *error) {
                    if(!error) {
                        [filters addObjectsFromArray:records];
                    }
                }];
                [operation start];
            }
        }
        
        // return results with respect to the existing records
        if(self.completion) {
            self.completion(self.records ? self.records : filters, self.records ? filters : nil, nil);
        }
    }
    else {
        if(self.completion) {
            self.completion(nil, nil, [BFError errorWithCode:BFErrorCodeNoData]);
        }
    }
    
}


@end



