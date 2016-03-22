//
//  NSArray+Map.h
//  OpenShop
//
//  Created by Justin Anderson. StackOverflow: http://stackoverflow.com/a/7248251/1092167
//

@import Foundation;

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end
