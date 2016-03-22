//
//  NSString+BFValidation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "NSString+BFValidation.h"

@implementation NSString (BFValidation)


#pragma mark - Email Validation

- (BOOL)isValidEmail {
    // empty string
    if(![self length]){
        return NO;
    }
    // simple regexp pattern
    NSString *emailRegExPattern = @"[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}";
    NSRegularExpression *emailRegEx = [[NSRegularExpression alloc] initWithPattern:emailRegExPattern options:NSRegularExpressionCaseInsensitive error:nil];
   
    return [emailRegEx numberOfMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])] == 1;
}

@end
