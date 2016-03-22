//
//  BFTranslationsParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTranslationsParsingOperation.h"
#import "BFTranslation.h"
#import "PersistentStorage.h"

/**
 * The translations language element key path in a raw JSON data.
 */
static NSString *const BFTranslationsParsingLanguageElementKey = @"lang";
/**
 * The translations strings element key path in a raw JSON data.
 */
static NSString *const BFTranslationsParsingTranslationKeysElementKey = @"translations";


@interface BFTranslationsParsingOperation ()


@end


@implementation BFTranslationsParsingOperation


#pragma mark - Parsing

- (void)main {
    // language
    NSString *translationsLanguage = (NSString *)[self.rawData objectForKey:BFTranslationsParsingLanguageElementKey];
    if(translationsLanguage) {
        // translation models
        NSMutableArray *translations = [[NSMutableArray alloc]init];
        // translations parsing
        [self.managedObjectContext performBlockAndWait:^{
            // strings
            NSDictionary *translationsStrings = (NSDictionary *)[self.rawData objectForKey:BFTranslationsParsingTranslationKeysElementKey];
            if(translationsStrings) {
                [translations addObjectsFromArray:[self dataModelsForTranslations:translationsStrings inLanguage:translationsLanguage]];
            }

            // save parsed records
            NSError *error;
            if ([self.managedObjectContext save:&error]) {
                if(self.completion) {
                    self.completion(translations, nil, nil);
                }
            }
            else {
                if(self.completion) {
                    self.completion(nil, nil, error);
                }
            }
        }];
    }
}


- (NSArray *)dataModelsForTranslations:(NSDictionary *)translationsStrings inLanguage:(NSString *)language {
    // translation models
    NSMutableArray *translations = [[NSMutableArray alloc]init];
    
    // parse translation strings
    for(id stringKey in translationsStrings) {
        // stop parsing if the operation has been cancelled
        if (self.isCancelled) {
            break;
        }
        NSString *translationValue = [translationsStrings objectForKey:stringKey];
        if(translationValue) {
            BFTranslation *translation = [NSEntityDescription insertNewObjectForEntityForName:[BFTranslation entityName] inManagedObjectContext:[[StorageManager defaultManager] privateQueueContext]];
            translation.language = language;
            translation.stringID = stringKey;
            translation.value = translationValue;
            [translations addObject:translation];
        }
    }
    
    return translations;
}


@end



