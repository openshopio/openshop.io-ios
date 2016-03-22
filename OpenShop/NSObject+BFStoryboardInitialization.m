//
//  NSObject+BFStoryboardInitization.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "NSObject+BFStoryboardInitialization.h"


/**
 * Main storyboard key identifier in application property list info.
 */
static NSString *const infoPropertyListMainStoryboardKey = @"UIMainStoryboardFile";


@implementation NSObject (BFStoryboardInitization)


#pragma mark - Storyboard Fetching

- (nullable UIViewController *)BFN_mainStoryboardClassInstanceWithClass:(Class)cls {
    return [self BFN_storyboardNamed:[self BFN_mainStoryboardName] classInstanceWithClass:cls];
}

- (nullable UIViewController *)BFN_mainStoryboardClassInstanceWithIdentifier:(NSString *)identifier {
    return [self BFN_storyboardNamed:[self BFN_mainStoryboardName] classInstanceWithIdentifier:identifier];
}

- (nullable UIViewController *)BFN_storyboardNamed:(NSString *)storyboardName classInstanceWithClass:(Class)cls {
    NSString *identifier = NSStringFromClass(cls);
    return [self BFN_storyboardNamed:storyboardName classInstanceWithIdentifier:identifier];
}

- (nullable UIViewController *)BFN_storyboardNamed:(NSString *)storyboardName classInstanceWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [self BFN_storyboardNamed:storyboardName];
    if(storyboard && identifier) {
        return [storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    return nil;
}


#pragma mark - Helpers 

-(NSString *)BFN_mainStoryboardName {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:infoPropertyListMainStoryboardKey];
}

-(UIStoryboard *)BFN_mainStoryboard {
    return [self BFN_storyboardNamed:[self BFN_mainStoryboardName]];
}

-(UIStoryboard *)BFN_storyboardNamed:(NSString *)storyboardName {
    NSBundle *bundle = [NSBundle mainBundle];
    return storyboardName ? [UIStoryboard storyboardWithName:storyboardName bundle:bundle] : nil;
}


@end



